Module("TeamMenu.Team")


local Utils = Require("TeamMenu.Utils")


local setmetatable = _G.setmetatable
local rawset = _G.rawset
local util = _G.util
local net = _G.net
local hook = _G.hook
local tostring = _G.tostring
local SetGlobalString = _G.SetGlobalString
local GetGlobalString = _G.GetGlobalString
local SetGlobalInt = _G.SetGlobalInt
local GetGlobalInt = _G.GetGlobalInt
local SetGlobalBool = _G.SetGlobalBool
local GetGlobalBool = _G.GetGlobalBool
local SetGlobalVar = _G.SetGlobalVar
local GetGlobalVar = _G.GetGlobalVar
local table = _G.table
local ErrorNoHaltWithStack = _G.ErrorNoHaltWithStack
local TEAM_CONNECTING = _G.TEAM_CONNECTING
local TEAM_SPECTATOR = _G.TEAM_SPECTATOR
local TEAM_UNASSIGNED = _G.TEAM_UNASSIGNED
local ipairs = _G.ipairs
local pairs = _G.pairs
local LocalPlayer = _G.LocalPlayer
local hook = _G.hook
local color_white = _G.color_white
local istable = _G.istable
local type = _G.type


local teams = _G.team.GetAllTeams()


cache = Utils.Table.GetValue(_G, "Uratrecom.Team.cache", {})


META = {}
META.__index = META


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


function META:SetJoinable(joinable)
    self.tbl.Joinable = joinable
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


function META:SetProperties(properties)
    self.tbl.Properties = properties
end


function META:GetProperties()
    return self.tbl.Properties
end


function META:SetProperty(key, value)
    self.tbl.Properties[key] = value
end


function META:GetProperty(key)
    return self.tbl.Properties[key]
end


function META:SetNWProperty(key, value)
    SetGlobalVar("Team." .. tostring(self.index) .. "." .. key, value)
end


function META:GetNWProperty(key)
    return GetGlobalVar("Team." .. tostring(self.index) .. "." .. key)
end


function META:SetNWPropertyKeys()
    Utils.SetGlobalVarArray(
        "Team." .. tostring(self.index) .. ".Properties",
        table.GetKeys(self:GetProperties())
    )
end


function META:GetNWPropertyKeys()
    return Utils.GetGlobalVarArray(
        "Team." .. tostring(self.index) .. ".Properties"
    )
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


function META:Copy(teamIndex)
    self:SafeReplaceTable(teams[teamIndex])
end


function META:Clone(teamIndex)
    teams[teamIndex] = table.Copy(self.tbl)

    return __call(teamIndex)
end


function META:Default()
    self:SetName("Unnamed")
    self:SetColor(color_white)
    self:SetScore(0)
    self:SetJoinable(true)
    self:SetSelectableClasses({})
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


function META:Share(player)
    if CLIENT then
        player = LocalPlayer()
    end


    if hook.Run("TeamMenu_CanShareTeam", self, player) == false then
        return
    end


    net.Start("TeamMenu_Share")
    net.WriteInt(self.index, 32)


    if CLIENT then
        net.WriteTable(self.tbl)
    end


    net.WriteBool(not self:IsValid())


    if SERVER then
        return player and net.Send(player) or net.Broadcast()
    end


    net.SendToServer()
end


function META:Pull()
    self:SetName(self:GetNWName())
    self:SetColor(self:GetNWColor())
    self:SetScore(self:GetNWScore())
    self:SetJoinable(self:GetNWJoinable())
    self:SetSelectableClasses(self:GetNWSelectableClasses())

    for _, key in ipairs(self:GetNWPropertyKeys()) do
        self:SetProperty(key, self:GetNWProperty(key))
    end
end


function META:Commit()
    self:SetNWName(self:GetName())
    self:SetNWColor(self:GetColor())
    self:SetNWScore(self:GetScore())
    self:SetNWJoinable(self:GetJoinable())
    self:SetNWSelectableClasses(self:GetSelectableClasses())


    for key, value in pairs(self:GetProperties()) do
        self:SetNWProperty(key, value)
    end


    self:SetNWPropertyKeys()
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
    if type(teamIndex) == "player" then
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


    if index == nil then
        local minIndex = Utils.Table.MinNumberKey(teams)
        local maxIndex = Utils.Table.MaxNumberKey(teams)


        for i = minIndex, maxIndex do
            if teams[i] == nil then
                index = i
                break
            end
        end


        index = index == nil and maxIndex + 1 or index
    end


    teamTable = Utils.Table.GetValue(teams, teamIndex, {
        Name = "Unnamed",
        Color = color_white,
        Score = 0,
        Joinable = true,
        SelectableClasses = {},
        SpawnPointTable = {},
        SpawnPoints = {}
    })


    Utils.Table.GetValue(teamTable, "Properties", {})


    local self = setmetatable({
        index = teamIndex,
        tbl = teamTable
    }, META)


    self:Initialize()


    cache[teamIndex] = self


    return self
end


New = __call


net.Receive("TeamMenu_Join", function(_, player)
    if player == nil then
        return
    end


    local teamIndex = net.ReadInt(32)
    local team = __call(teamIndex)


    if not player:IsAdmin() and not team:GetJoinable() then
        return
    end


    team:Join(player)


    net.Start("TeamMenu_OnJoin")
    net.WriteInt(teamIndex,  32)
    net.Send(player)
end)


net.Receive("TeamMenu_OnJoin", function(_, player)
    if player ~= nil then
        return
    end


    local teamIndex = net.ReadInt(32)


    hook.Run("TeamMenu_OnPlayerJoinTeam", __call(teamIndex), LocalPlayer())
end)


net.Receive("TeamMenu_Share", function(_, player)
    if player then
        local teamIndex = net.ReadInt(32)
        local teamTable = net.ReadTable()
        local isRemoved = net.ReadBool()


        if not player:IsAdmin() then
            return
        end


        local team = __call(teamIndex)


        team:SafeReplaceTable(teamTable)
        team:Commit()


        if isRemoved then
            team:Remove()
        end


        net.Start("TeamMenu_Share")
        net.WriteInt(teamIndex, 32)
        net.WriteBool(isRemoved)
        net.Broadcast()
    else
        local teamIndex = net.ReadInt(32)
        local isRemoved = net.ReadBool()
        local team = __call(teamIndex)


        team:Pull()


        if isRemoved then
            team:Remove()
        end
    end
end)


if SERVER then
    hook.Add("PlayerInitialSpawn", "TeamMenu_SetUpTeams", function(player)
        for teamIndex in ipairs(teams) do
            __call(teamIndex):Share(player)
        end
    end)
end