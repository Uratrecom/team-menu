Module("TeamMenu.Team")


local Utils = Require("TeamMenu.Utils")


local setmetatable = _G.setmetatable
local rawset = _G.rawset
local util = _G.util
local net = _G.net
local hook = _G.hook


local teams = _G.team.GetAllTeams()


cache = {}
META = {}


if SERVER then
    util.AddNetworkString("TeamMenu_Join")
    util.AddNetworkString("TeamMenu_Share")
    util.AddNetworkString("TeamMenu_OnJoin")
end


setmetatable(teams, {
    __newindex = function(self, teamIndex, teamTable)
        rawset(self, teamIndex, teamTable)


        if teamTable == nil then
            return
        end


        hook.Run("TeamMenu_TeamCreated", _M(teamIndex))
    end
})


function META:SetIndex(index)
    self.index = index
end


function META:GetIndex()
    return self.index
end


function META:SetTable(tbl)
    self.tbl = tbl
end


function META:GetTable()
    return self.tbl
end


function META:SetName(name)
    self.tbl.Name = name
end


function META:GetName()
    return self.tbl.Name
end


function META:SetNWName(name)
    SetGlobalString("Team." .. tostring(self.index) .. ".Name", name)
end


function META:GetNWName()
    return GetGlobalString("Team." .. tostring(self.index) .. ".Name")
end


function META:SetColor(color)
    self.tbl.Color = color
end


function META:GetColor()
    return self.tbl.Color
end


function META:SetNWColor(color)
    SetGlobalString("Team." .. tostring(self.index) .. ".Color", tostring(color))
end


function META:GetNWColor()
    return GetGlobalString("Team." .. tostring(self.index) .. ".Color"):ToColor()
end


function META:SetScore(score)
    self.tbl.Score = score
end


function META:GetScore()
    return self.tbl.Score
end


function META:SetNWScore(score)
    SetGlobalInt("Team." .. tostring(self.index) .. ".Score", score)
end


function META:GetNWScore()
    return GetGlobalInt("Team." .. tostring(self.index) .. ".Score")
end


function META:SetJoinable(isJoinable)
    self.tbl.Joinable = isJoinable
end


function META:GetJoinable()
    return self.tbl.Joinable
end


function META:SetNWJoinable(isJoinable)
    SetGlobalBool("Team." .. tostring(self.index) .. ".Joinable", isJoinable)
end


function META:GetNWJoinable()
    return SetGlobalBool("Team." .. tostring(self.index) .. ".Joinable")
end


function META:SetSelectableClasses(selectableClasses)
    self.tbl.SelectableClasses = selectableClasses
end


function META:GetSelectableClasses()
    return self.tbl.SelectableClasses
end


function META:SetNWSelectableClasses(selectableClasses)
    Utils.SetGlobalVarArray(
        "Team." .. tostring(self.index) .. ".SelectableClasses",
        selectableClasses
    )
end


function META:GetNWSelectableClasses()
    return Utils.GetGlobalVarArray(
        "Team." .. tostring(self.index) .. ".SelectableClasses"
    )
end


function META:GetValues()
    return self.tbl.Values
end


function META:SetValue(key, value)
    self.tbl.Values[key] = value
end


function META:GetValue(key)
    return self.tbl.Values[key]
end


function META:SetNWValue(key, value)
    SetGlobalVar("Team." .. tostring(self.index) .. "." .. key, value)
end


function META:GetNWValue(key)
    return GetGlobalVar("Team." .. tostring(self.index) .. "." .. key)
end


function META:SetNWValues()
    Utils.SetGlobalVarArray(
        "Team." .. tostring(self.index) .. ".Values",
        table.GetKeys(self:GetValues())
    )
end


function META:GetNWValues()
    return Utils.GetGlobalVarArray("Team." .. tostring(self.index) .. ".Values")
end


function META:Restore()
    if istable(teams[self.index]) and teams[self.index] ~= self.tbl then
        ErrorNoHaltWithStack(("Overwriting the existing team (%s -> %s)"):format(
            teams[self.index].Name,
            self:GetName()
        ))
    end


    teams[self.index] = self.tbl
    cache[self.index] = self
end


function META:Default()
    self:SetName("Unnamed")
    self:SetColor(color_white)
    self:SetScore(0)
    self:SetJoinable(true)
    self:SetSelectableClasses({})

    if self:GetAutoShare() then
        self:AddToShare()
    end
end


function META:Initialize()
    if self:GetName() == nil then
        self:SetName("Unnamed")
    end


    if self:GetColor() == nil then
        self:SetColor(color_white)
    end


    if self:GetScore() == nil then
        self:SetScore(0)
    end


    if self:GetJoinable() == nil then
        self:SetJoinable(true)
    end


    if self:GetSelectableClasses() == nil then
        self:SetSelectableClasses({})
    end
end


function META:Share(ply)
    if CLIENT then
        ply = LocalPlayer()
    end

    
    if hook.Run("TeamMenu_CanShareTeam", self, ply) == false then
        return
    end


    net.Start("TeamMenu_Share")
    net.WriteInt(self.index, 32)
    net.WriteTable(self.tbl)
    net.WriteBool(not self:IsValid())


    if SERVER and ply then
        net.Send(ply)
        return
    end


    if SERVER then
        net.Broadcast()
        return
    end


    net.SendToServer()
end


function META:Pull()
    self:SetName(self:GetNWName())
    self:SetColor(self:GetNWColor())
    self:SetScore(self:GetNWScore())
    self:SetJoinable(self:GetNWJoinable())
    self:SetSelectableClasses(self:GetNWSelectableClasses())


    local keys = self:GetNWValues()


    for _, key in pairs(keys) do
        self:SetValue(key, self:GetNWValue(key))
    end
end


function META:Commit()
    self:SetNWName(self:GetName())
    self:SetNWColor(self:GetColor())
    self:SetNWScore(self:GetScore())
    self:SetNWJoinable(self:GetJoinable())
    self:SetNWSelectableClasses(self:GetSelectableClasses())


    for key, value in pairs(self:GetValues()) do
        self:SetNWValue(key, value)
    end


    self:SetNWCustomKeys()
end


function META:Remove()
    if istable(teams[index]) and teams[index] ~= self.tbl then
        ErrorNoHaltWithStack(("Removing an existing team (%s -> nil)"):format(
            teams[index].Name
        ))
    end


    if hook.Run("TeamMenu_CanRemoveTeam", self) == false then
        return
    end


    cache[self.index] = nil
    teams[self.index] = nil


    hook.Run("TeamMenu_TeamRemoved", self)
end

    
function META:SafeReplaceTable(tbl)
    table.CopyFromTo(tbl, self.tbl)
end


function META:HasPlayer(player)
    return player:Team() == self.index
end


function META:IsUnassignedTeam()
    return self.index == TEAM_UNASSIGNED
end


function META:IsSpectatorTeam()
    return self.index == TEAM_SPECTATOR
end


function META:IsConnectingTeam()
    return self.index == TEAM_CONNECTING
end


function META:IsDefaultTeam()
    return self:IsUnassignedTeam() or
           self:IsSpectatorTeam() or
           self:IsConnectingTeam()
end


function META:Join(player)
    if CLIENT then
        player = LocalPlayer()
    end


    if hook.Run("TeamMenu_CanPlayerJoinTeam", self, player) == false then
        return
    end


    if SERVER then
        player:SetTeam(self.index)


        hook.Run("TeamMenu_OnPlayerJoinTeam")


        return
    end


    net.Start("TeamMenu_Join")
    net.WriteInt(self.index, 32)
    net.SendToServer()
end


function META:Leave(player)
    if CLIENT then
        player = LocalPlayer()
    end


    if hook.Run("TeamMenu_CanPlayerLeaveTeam", self, player) == false then
        return
    end


    if SERVER then
        player:SetTeam(TEAM_UNASSIGNED)


        hook.Run("TeamMenu_OnPlayerLeaveTeam", self, player)


        return
    end


    __call(TEAM_UNASSIGNED):Join()


    hook.Run("TeamMenu_OnPlayerLeaveTeam", self, player)
end


function META:GetPlayers()
    return _G.team.GetPlayers(self.index)
end


function META:NumPlayers()
    return _G.team.NumPlayers(self.index)
end


META.GetNumberPlayers = META.NumPlayers


function META:TotalDeaths()
    return _G.team.TotalDeaths(self.index)
end


META.GetDeaths = META.TotalDeaths


function META:TotalFrags()
    return _G.team.TotalFrags(self.index)
end


META.GetFrags = META.TotalFrags


function META:SetClass(classes)
    _G.team.SetClass(self.index, classes)
end


function META:GetClass()
    return _G.team.GetClass(self.index)
end


function META:AddScore(increment)
    _G.team.AddScore(self.index, increment)
end


function META:SetSpawnPoint(classes)
    _G.team.SetSpawnPoint(self.index, classes)
end


META.SetSpawnPointTable = META.SetSpawnPoint


function META:GetSpawnPoint()
    return _G.team.GetSpawnPoint(self.index)
end


META.GetSpawnPointTable = META.GetSpawnPoint


function META:GetSpawnPoints()
    return _G.team.GetSpawnPoints(self.index)
end


function META:Valid()
    return _G.team.Valid(self.index)
end


META.IsValid = META.Valid


function __call(teamIndex)
    if not Utils.CheckArguments(teamIndex) then
        return
    end


    if Utils.IsPlayer(teamIndex) then
        teamIndex = teamIndex:Team()
    end


    local teamTable = teams[teamIndex]
    local teamCache = cache[teamIndex]


    if teamCache then
        if teamCache.tbl ~= teamTable then
            teams[teamIndex] = teamCache.tbl
        end

        return teamCache
    end


    if teamIndex == nil then
        local minIndex = Utils.table.MinNumberKey(teams)
        local maxIndex = Utils.table.MaxNumberKey(teams)


        for i = minIndex, maxIndex do
            if not teams[i] then
                teamIndex = i
                break
            end
        end


        teamIndex = teamIndex == nil and maxIndex+1 or teamIndex
    end


    teams[teamIndex] = teamTable or {
        Name = "Unnamed",
        Color = color_white,
        Score = 0,
        Joinable = true,
        SelectableClasses = {},
        SpawnPointTable = {},
        SpawnPoints = {}
    }


    if teams[teamIndex].Values == nil then
        teams[teamIndex].Values = {}
    end


    local self = setmetatable({
        index = teamIndex,
        tbl = teams[teamIndex],
        autoShare = false
    }, TEAM)


    cache[teamIndex] = self


    return self
end


Utils.AddArguments(TeamMenu.Team, {
    { name = "teamIndex", required = false, type = { "number", "Player" } }
})


net.Receive("TeamMenu_Join", function(_, ply)
    if not ply then
        return
    end


    local teamIndex = net.ReadInt(32)
    local team = TeamMenu.Team(teamIndex)


    if not ply:IsAdmin() and not team:GetJoinable() then
        return
    end


    team:Join(ply)


    net.Start("TeamMenu_OnJoin")
    net.WriteInt(teamIndex,  32)
    net.Send(ply)
end)


net.Receive("TeamMenu_OnJoin", function(_, ply)
    if ply then
        return
    end


    local teamIndex = net.ReadInt(32)


    hook.Run("TeamMenu_OnPlayerJoinTeam", _M(teamIndex), LocalPlayer())
end)


net.Receive("TeamMenu_Share", function(_, ply)
    local teamIndex = net.ReadInt(32)
    local teamTable = net.ReadTable()
    local isRemoved = net.ReadBool()
    local team = _M(teamIndex)


    if ply and not ply:IsAdmin() then
        return
    end


    if isRemoved then
        team:Remove()

        if CLIENT and team:HasPlayer(LocalPlayer()) then
            team:Leave()
        end
    end


    team:SafeReplaceTable(teamTable)


    hook.Run("TeamMenu_TeamUpdated", team, isRemoved)


    if ply then
        team:Commit()
        team:Share()
    end
end)


if SERVER then
    hook.Add("PlayerInitialSpawn", "TeamMenu_SetUpTeams", function(ply)
        for teamIndex in pairs(teams) do
            TeamMenu.Team(teamIndex):Share(ply)
        end
    end)
end