--[[

Written By Uratrecom.

List of available hooks:
    CanShareTeam
    CanRemoveTeam
    CanPlayerJoinTeam
    CanPlayerLeaveTeam
    OnPlayerJoinTeam
    OnPlayerLeaveTeam
    TeamCreated
    TeamUpdated
    TeamRemoved
--]]


if SERVER then
    util.AddNetworkString("TeamMenu_Join")
    util.AddNetworkString("TeamMenu_Share")
    util.AddNetworkString("TeamMenu_OnJoin")
end


local cache = {}
local teams = team.GetAllTeams()
local toShare = {}


setmetatable(teams, {
    __newindex = function(self, teamIndex, teamTable)
        rawset(self, teamIndex, teamTable)


        if teamTable == nil then
            return
        end


        hook.Run("TeamMenu_TeamCreated", TeamMenu.Team(teamIndex))
    end
})


TeamMenu.TEAM = TeamMenu.TEAM or {}


local Utils = TeamMenu.Utils
local TEAM = TeamMenu.TEAM


TEAM.__index = TEAM


function TEAM:SetIndex(index)
    if not Utils.CheckArguments(index) then
        return
    end

    self.index = index
end


Utils.AddArguments(TEAM.SetIndex, {
    { name = "index", required = true, type = "number" }
})


function TEAM:GetIndex()
    return self.index
end


function TEAM:SetTable(tbl)
    if not Utils.CheckArguments(tbl) then
        return
    end


    self.tbl = tbl


    if self:GetAutoShare() then
        self:AddToShare()
    end
end


Utils.AddArguments(TEAM.SetTable, {
    { name = "tbl", required = true, type = "table" }
})


function TEAM:GetTable()
    return self.tbl
end


function TEAM:SetName(name)
    if not Utils.CheckArguments(name) then
        return
    end


    self.tbl.Name = name


    if self:GetAutoShare() then
        self:AddToShare()
    end
end


Utils.AddArguments(TEAM.SetName, {
    { name = "name", required = true, type = "string" }
})


function TEAM:GetName()
    return self.tbl.Name
end


function TEAM:SetNWName(name)
    if not Utils.CheckArguments(name) then
        return
    end

    SetGlobalString("Team." .. tostring(self.index) .. ".Name", name)
end


Utils.AddArguments(TEAM.SetNWName, {
    { name = "name", required = true, type = "string" }
})


function TEAM:GetNWName()
    return GetGlobalString("Team." .. tostring(self.index) .. ".Name")
end


function TEAM:SetColor(color)
    if not Utils.CheckArguments(color) then
        return
    end


    self.tbl.Color = color


    if self:GetAutoShare() then
        self:AddToShare()
    end
end


Utils.AddArguments(TEAM.SetColor, {
    { name = "color", required = true, type = "table", validator = Utils.ColorValidator }
})


function TEAM:GetColor()
    return self.tbl.Color
end


function TEAM:SetNWColor(color)
    if not Utils.CheckArguments(color) then
        return
    end

    SetGlobalString("Team." .. tostring(self.index) .. ".Color", tostring(color))
end


Utils.AddArguments(TEAM.SetNWColor, {
    { name = "color", required = true, type = "table", validator = Utils.ColorValidator }
})


function TEAM:GetNWColor()
    return GetGlobalString("Team." .. tostring(self.index) .. ".Color"):ToColor()
end


function TEAM:SetScore(score)
    if not Utils.CheckArguments(score) then
        return
    end


    self.tbl.Score = score

    if self:GetAutoShare() then
        self:AddToShare()
    end
end


Utils.AddArguments(TEAM.SetScore, {
    { name = "score", required = true, type = "number" }
})


function TEAM:GetScore()
    return self.tbl.Score
end


function TEAM:SetNWScore(score)
    if not Utils.CheckArguments(score) then
        return
    end

    SetGlobalInt("Team." .. tostring(self.index) .. ".Score", score)
end


Utils.AddArguments(TEAM.SetNWScore, {
    { name = "score", required = true, type = "number" }
})


function TEAM:GetNWScore()
    return GetGlobalInt("Team." .. tostring(self.index) .. ".Score")
end


function TEAM:SetJoinable(isJoinable)
    if not Utils.CheckArguments(isJoinable) then
        return
    end


    self.tbl.Joinable = isJoinable


    if self:GetAutoShare() then
        self:AddToShare()
    end
end


Utils.AddArguments(TEAM.SetJoinable, {
    { name = "isJoinable", required = true, type = "boolean" }
})


function TEAM:GetJoinable()
    return self.tbl.Joinable
end


function TEAM:SetNWJoinable(isJoinable)
    if not Utils.CheckArguments(isJoinable) then
        return
    end

    SetGlobalBool("Team." .. tostring(self.index) .. ".Joinable", isJoinable)
end


Utils.AddArguments(TEAM.SetNWJoinable, {
    { name = "isJoinable", required = true, type = "boolean" }
})


function TEAM:GetNWJoinable()
    return SetGlobalBool("Team." .. tostring(self.index) .. ".Joinable")
end


function TEAM:SetSelectableClasses(selectableClasses)
    if not Utils.CheckArguments(value) then
        return
    end


    self.tbl.SelectableClasses = selectableClasses


    if self:GetAutoShare() then
        self:AddToShare()
    end
end


Utils.AddArguments(TEAM.SetSelectableClasses, {
    { name = "selectableClasses", required = true, type = "table" }
})


function TEAM:GetSelectableClasses()
    return self.tbl.SelectableClasses
end


function TEAM:SetNWSelectableClasses(selectableClasses)
    if not Utils.CheckArguments(value) then
        return
    end

    Utils.SetGlobalVarArray("Team." .. tostring(self.index) .. ".SelectableClasses", selectableClasses)
end


Utils.AddArguments(TEAM.SetNWSelectableClasses, {
    { name = "selectableClasses", required = true, type = "table" }
})


function TEAM:GetNWSelectableClasses()
    return Utils.GetGlobalVarArray("Team." .. tostring(self.index) .. ".SelectableClasses")
end


function TEAM:GetValues()
    return self.tbl.Values
end


function TEAM:SetValue(key, value)
    if not Utils.CheckArguments(key, value) then
        return
    end


    self.tbl.Values[key] = value


    if self:GetAutoShare() then
        self:AddToShare()
    end
end


Utils.AddArguments(TEAM.SetValue, {
    { name = "key", required = true, type = "string" },
    { name = "value", required = true, type = { "string", "number", "boolean" } }
})


function TEAM:GetValue(key)
    return self.tbl.Values[key]
end


function TEAM:SetNWValue(key, value)
    if not Utils.CheckArguments(key, value) then
        return
    end

    SetGlobalVar("Team." .. tostring(self.index) .. "." .. key, value)
end


Utils.AddArguments(TEAM.SetNWValue, {
    { name = "key", required = true, type = "string" },
    { name = "value", required = true, type = { "string", "number", "boolean" } }
})


function TEAM:GetNWValue(key)
    if not Utils.CheckArguments(key) then
        return
    end

    return GetGlobalVar("Team." .. tostring(self.index) .. "." .. key)
end


Utils.AddArguments(TEAM.GetNWValue, {
    { name = "key", required = true, type = "string" }
})


function TEAM:SetNWValues()
    Utils.SetGlobalVarArray(
        "Team." .. tostring(self.index) .. ".Values",
        table.GetKeys(self:GetValues())
    )
end


function TEAM:GetNWValues()
    return Utils.GetGlobalVarArray("Team." .. tostring(self.index) .. ".Values")
end


function TEAM:SetAutoShare(autoShare)
    if not Utils.CheckArguments(autoShare) then
        return
    end

    self.autoShare = autoShare
end


Utils.AddArguments(TEAM.SetAutoShare, {
    { name = "autoShare", required = true, type = "boolean" }
})


function TEAM:GetAutoShare(value)
    return self.autoShare
end


function TEAM:ToggleAutoShare()
    self:SetAutoShare(not self:GetAutoShare())
end


function TEAM:Restore()
    if istable(teams[self.index]) and teams[self.index] ~= self.tbl then
        ErrorNoHaltWithStack(("Overwriting the existing team (%s -> %s)"):format(
            teams[self.index].Name,
            self:GetName()
        ))
    end


    teams[self.index] = self.tbl
    cache[self.index] = self


    if self:GetAutoShare() then
        self:AddToShare()
    end
end


function TEAM:Default()
    self:SetName("Unnamed")
    self:SetColor(color_white)
    self:SetScore(0)
    self:SetJoinable(true)
    self:SetSelectableClasses({})

    if self:GetAutoShare() then
        self:AddToShare()
    end
end


function TEAM:Initialize()
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


    if self:GetAutoShare() then
        self:AddToShare()
    end
end

function TEAM:Share(ply)
    if not Utils.CheckArguments(ply) then
        return
    end


    toShare[self] = nil


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


if SERVER then
    Utils.AddArguments(TEAM.Share, {
        { name = "ply", required = false, type = "Player" }
    })
else
    Utils.AddArguments(TEAM.Share, {
        { name = "ply", required = false, type = "any" }
    })
end


function TEAM:Pull()
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


function TEAM:Commit()
    self:SetNWName(self:GetName())
    self:SetNWColor(self:GetColor())
    self:SetNWScore(self:GetScore())
    self:SetNWJoinable(self:GetJoinable())
    self:SetNWSelectableClasses(self:GetSelectableClasses())


    for key, value in pairs(self:GetValues()) do
        self:SetNWValue(key, value)
    end


    self:SetNWCustomKeys()


    if self:GetAutoShare() then
        self:AddToShare()
    end
end


function TEAM:Remove()
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


    if self:GetAutoShare() then
        self:AddToShare()
    end
end

    
function TEAM:SafeReplaceTable(tbl)
    if not Utils.CheckArguments(tbl) then
        return
    end

    table.CopyFromTo(tbl, self.tbl)
end


Utils.AddArguments(TEAM.SafeReplaceTable, {
    { name = "value", required = true, type = "table" }
})


function TEAM:HasPlayer(ply)
    if not Utils.CheckArguments(ply) then
        return
    end

    return ply:Team() == self.index
end


Utils.AddArguments(TEAM.HasPlayer, {
    { name = "ply", required = true, type = "Player" }
})


function TEAM:IsUnassignedTeam()
    return self.index == TEAM_UNASSIGNED
end


function TEAM:IsSpectatorTeam()
    return self.index == TEAM_SPECTATOR
end


function TEAM:IsConnectingTeam()
    return self.index == TEAM_CONNECTING
end


function TEAM:IsDefaultTeam()
    return self:IsUnassignedTeam() or self:IsSpectatorTeam() or self:IsConnectingTeam()
end


function TEAM:Join(ply)
    if not Utils.CheckArguments(ply) then
        return
    end


    if CLIENT then
        ply = LocalPlayer()
    end


    if hook.Run("TeamMenu_CanPlayerJoinTeam", self, ply) == false then
        return
    end


    if SERVER then
        ply:SetTeam(self.index)


        hook.Run("TeamMenu_OnPlayerJoinTeam")


        return
    end


    net.Start("TeamMenu_Join")
    net.WriteInt(self.index, 32)
    net.SendToServer()
end


if SERVER then
    Utils.AddArguments(TEAM.Join, {
        { name = "ply", required = true, type = "Player", validator }
    })
else
    Utils.AddArguments(TEAM.Join, {
        { name = "ply", required = false, type = "any" }
    })
end


function TEAM:Leave(ply)
    if not Utils.CheckArguments(ply) then
        return
    end


    if CLIENT then
        ply = LocalPlayer()
    end


    if hook.Run("TeamMenu_CanPlayerLeaveTeam", self, ply) == false then
        return
    end


    if SERVER then
        ply:SetTeam(TEAM_UNASSIGNED)


        hook.Run("TeamMenu_OnPlayerLeaveTeam", self, ply)


        return
    end


    TeamMenu.Team(TEAM_UNASSIGNED):Join()


    hook.Run("TeamMenu_OnPlayerLeaveTeam", self, ply)
end


if SERVER then
    Utils.AddArguments(TEAM.Leave, {
        { name = "ply", required = true, type = "Player" }
    })
else
    Utils.AddArguments(TEAM.Leave, {
        { name = "ply", required = false, type = "any" }
    })
end


function TEAM:AddToShare()
    toShare[self] = true
end


function TEAM:GetPlayers()
    return team.GetPlayers(self.index)
end


function TEAM:NumPlayers()
    return team.NumPlayers(self.index)
end


TEAM.GetNumberPlayers = TEAM.NumPlayers


function TEAM:TotalDeaths()
    return team.TotalDeaths(self.index)
end


TEAM.GetDeaths = TEAM.TotalDeaths


function TEAM:TotalFrags()
    return team.TotalFrags(self.index)
end


TEAM.GetFrags = TEAM.TotalFrags


function TEAM:SetClass(classes)
    if not Utils.CheckArguments(value) then
        return
    end


    team.SetClass(self.index, classes)


    if self:GetAutoShare() then
        self:AddToShare()
    end
end


Utils.AddArguments(TEAM.SetClass, {
    { name = "value", required = true, type = "table" }
})


function TEAM:GetClass()
    return team.GetClass(self.index)
end


function TEAM:AddScore(increment)
    if not Utils.CheckArguments(value) then
        return
    end

    team.AddScore(self.index, increment)
end


Utils.AddArguments(TEAM.AddScore, {
    { name = "increment", required = true, type = "number" }
})


function TEAM:SetSpawnPoint(classes)
    if not Utils.CheckArguments(classes) then
        return
    end

    team.SetSpawnPoint(self.index, classes)
end


Utils.AddArguments(TEAM.SetSpawnPoint, {
    { name = "classes", required = true, type = "table" }
})


TEAM.SetSpawnPointTable = TEAM.SetSpawnPoint


function TEAM:GetSpawnPoint()
    return team.GetSpawnPoint(self.index)
end


TEAM.GetSpawnPointTable = TEAM.GetSpawnPoint


function TEAM:GetSpawnPoints()
    return team.GetSpawnPoints(self.index)
end


function TEAM:Valid()
    return team.Valid(self.index)
end


TEAM.IsValid = TEAM.Valid


function TeamMenu.Team(teamIndex)
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


    hook.Run("TeamMenu_OnPlayerJoinTeam", TeamMenu.Team(teamIndex), LocalPlayer())
end)


net.Receive("TeamMenu_Share", function(_, ply)
    local teamIndex = net.ReadInt(32)
    local teamTable = net.ReadTable()
    local isRemoved = net.ReadBool()
    local team = TeamMenu.Team(teamIndex)


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


hook.Add("Think", "Team_AutoShareThink", function()
    for team in pairs(toShare) do
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