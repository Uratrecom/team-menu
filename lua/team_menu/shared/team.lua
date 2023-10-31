Uratrecom.Module("Uratrecom.TeamMenu.Team", Uratrecom.TeamMenu)


if SERVER then
    util.AddNetworkString("Uratrecom_TeamMenu_Join")
    util.AddNetworkString("Uratrecom_TeamMenu_Share")
    util.AddNetworkString("Uratrecom_TeamMenu_OnJoin")
end


Teams = team.GetAllTeams()
Cache = Cache or {}


META = META or {}
META.__index = META


do
    local metatable = getmetatable(Teams) or {}
    local old_handler = metatable.__newindex

    function metatable:__newindex(team_index, team_data)
        if isfunction(old_handler) then
            old_handler(self, team_index, team_data)
        else
            rawset(self, team_index, team_data)
        end

        if team_data == nil or Cache[team_index] ~= nil then
            return
        end

        hook.Run("Uratrecom_TeamMenu_TeamCreated", New(team_index))
    end

    setmetatable(Teams, metatable)
end


function New(team_index)
    if type(team_index) == "player" then
        team_index = team_index:Team()
    end

    if team_index == nil or not isnumber(team_index) then
        local min_index = Utils.TableMinIndex(Teams)
        local max_index = Utils.TableMaxIndex(Teams)

        for index = min_index, max_index do
            if Teams[index] == nil then
                team_index = index
                break
            end
        end

        team_index = team_index == nil and max_index + 1 or team_index
    end

    local team_data = Teams[team_index]
    local team_cache = Cache[team_index]

    if team_cache then
        if team_cache.Table ~= team_data then
            Teams[team_index] = team_cache.Table
        end

        return team_cache
    end

    team_data = Uratrecom.Get(Teams, team_index, {}, true)

    local self = setmetatable({
        Index = team_index,
        Data = team_data
    }, META)

    self:InitializeFields()

    Cache[team_index] = self

    return self
end


function RemoveTeam(team_index)
    New(team_index):Remove()
end


function RemoveAllTeams()
    for team_index in ipairs(teams) do
        RemoveTeam(team_index)
    end
end


function TeamExists(team_index)
    return Teams[team_index] ~= nil
end


AccessorFunc(META, "Index", "Index", FORCE_NUMBER)
AccessorFunc(META, "Data", "Data")


function META:SetName(name)
    self.Data.Name = name
end


function META:GetName()
    return self.Data.Name
end


function META:SetNWName(name)
    if CLIENT then
        return
    end

    SetGlobal2String("Team." .. tostring(self.Index) .. ".Name", name)
end


function META:GetNWName()
    return GetGlobal2String("Team." .. tostring(self.Index) .. ".Name", "Unnamed")
end


function META:SetColor(color)
    self.Data.Color = color
end


function META:GetColor()
    return self.Data.Color
end


function META:SetNWColor(color)
    if CLIENT then
        return
    end

    SetGlobal2String("Team." .. tostring(self.Index) .. ".Color", tostring(color))
end


function META:GetNWColor()
    return GetGlobal2String("Team." .. tostring(self.Index) .. ".Color"):ToColor()
end


function META:SetScore(score)
    self.Data.Score = score
end


function META:GetScore()
    return self.Data.Score
end


function META:SetNWScore(score)
    if CLIENT then
        return
    end

    SetGlobal2Int("Team." .. tostring(self.Index) .. ".Score", score)
end


function META:GetNWScore()
    return GetGlobal2Int("Team." .. tostring(self.Index) .. ".Score")
end


function META:SetJoinable(is_joinable)
    self.Data.Joinable = is_joinable
end


function META:IsJoinable()
    return self.Data.Joinable
end


function META:SetNWJoinable(is_joinable)
    if CLIENT then
        return
    end

    SetGlobal2Bool("Team." .. tostring(self.Index) .. ".Joinable", is_joinable)
end


function META:IsNWJoinable()
    return SetGlobal2Bool("Team." .. tostring(self.Index) .. ".Joinable")
end


function META:SetSelectableClasses(selectable_classes)
    self.Data.SelectableClasses = selectable_classes
end


function META:GetSelectableClasses()
    return self.Data.SelectableClasses
end


function META:SetNWSelectableClasses(selectable_classes)
    if CLIENT then
        return
    end
    
    Utils.SetGlobalVarArray(
        "Team." .. tostring(self.Index) .. ".SelectableClasses",
        selectable_classes
    )
end


function META:GetNWSelectableClasses()
    return Utils.GetGlobalVarArray(
        "Team." .. tostring(self.Index) .. ".SelectableClasses"
    )
end


function META:SetProperties(properties)
    self.Data.Properties = properties
end


function META:GetProperties()
    return self.Data.Properties
end


function META:SetProperty(key, value)
    self.Data.Properties[key] = value
end


function META:GetProperty(key)
    return self.Data.Properties[key]
end


function META:SetNWProperty(key, value)
    if CLIENT then
        return
    end

    SetGlobal2Var("Team." .. tostring(self.Index) .. ".Property." .. key, value)
end


function META:GetNWProperty(key)
    return GetGlobal2Var("Team." .. tostring(self.Index) .. ".Property." .. key)
end


function META:SetNWPropertyKeys()
    if CLIENT then
        return
    end

    Utils.SetGlobalVarArray(
        "Team." .. tostring(self.Index) .. ".PropertyKeys",
        table.GetKeys(self:GetProperties())
    )
end


function META:GetNWPropertyKeys()
    return Utils.GetGlobalVarArray(
        "Team." .. tostring(self.Index) .. ".PropertyKeys"
    )
end


function META:SetRemoved(is_removed)
    self.Data.Removed = is_removed
end


function META:IsRemoved()
    return self.Data.Removed
end


function META:SetNWRemoved(is_removed)
    if CLIENT then
        return
    end

    SetGlobal2Bool("Team." .. tostring(self.Index) .. "Removed", is_removed)
end


function META:GetNWRemoved()
    return GetGlobal2Bool("Team." .. tostring(self.Index) .. "Removed")
end


function META:Restore()
    if istable(teams[self.Index]) and teams[self.Index] ~= self.Table then
        ErrorNoHaltWithStack(("Overwriting the existing team (%s -> %s)"):format(
            teams[self.Index].Name,
            self:GetName()
        ))
    end

    Teams[self.Index] = self.Data
    Cache[self.Index] = self
end


function META:Clone(team_index)
    Teams[team_index] = table.Copy(self.Data)

    return New(team_index)
end


function META:Default()
    self:SetName("Unnamed")
    self:SetColor(color_white)
    self:SetScore(0)
    self:SetJoinable(true)
    self:SetSelectableClasses({})
    self:SetProperties({})
end


function META:InitializeFields()
    if self:GetName() == nil or self:GetName() == "" then
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

    if self:GetProperties() == nil then
        self:SetProperties({})
    end
end


function META:Share(ply)
    net.Start("Uratrecom_TeamMenu_Share")
    net.WriteInt(self.Index, 32)
    net.WriteBool(not self:IsValid())
    net.WriteTable(self.Data)

    if CLIENT then
        net.SendToServer()

        return 
    end

    if Utils.IsPlayer(ply) then
        net.Send(ply)

        return
    end

    net.Broadcast()
end


function META:Pull()
    self:SetName(self:GetNWName())
    self:SetRemoved(self:GetNWRemoved())
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
    self:SetNWRemoved(self:IsRemoved())
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
    if istable(Teams[self.Index]) and Teams[self.Index] ~= self.Data then
        ErrorNoHaltWithStack(("Removing an existing team (%s -> nil)"):format(
            Teams[index].Name
        ))
    end

    Cache[self.Index] = nil
    Teams[self.Index] = nil
end


function META:SafeReplaceTable(tbl)
    table.Empty(self.Data)
    table.Merge(self.Data, tbl)
end


function META:HasPlayer(ply)
    return ply:Team() == self.Index
end


function META:HasLocalPlayer()
    return CLIENT and self:HasPlayer(LocalPlayer())
end


function META:IsUnassignedTeam()
    return self.Index == TEAM_UNASSIGNED
end


function META:IsSpectatorTeam()
    return self.Index == TEAM_SPECTATOR
end


function META:IsConnectingTeam()
    return self.Index == TEAM_CONNECTING
end


function META:IsDefaultTeam()
    return self:IsUnassignedTeam() or
           self:IsSpectatorTeam() or
           self:IsConnectingTeam()
end


function META:Join(ply)
    if SERVER then
        if Utils.IsPlayer(ply) then
            ply:SetTeam(self.Index)
        end

        return
    end

    net.Start("Uratrecom_TeamMenu_Join")
    net.WriteInt(self.Index, 32)
    net.SendToServer()
end


function META:Leave(player)
    if SERVER then
        player:SetTeam(TEAM_UNASSIGNED)

        return
    end

    New(TEAM_UNASSIGNED):Join()
end


function META:GetPlayers()
    return team.GetPlayers(self.Index)
end


function META:NumPlayers()
    return team.NumPlayers(self.Index)
end


META.GetNumberPlayers = META.NumPlayers


function META:TotalDeaths()
    return team.TotalDeaths(self.Index)
end


META.GetDeaths = META.TotalDeaths


function META:TotalFrags()
    return team.TotalFrags(self.Index)
end


META.GetFrags = META.TotalFrags


function META:SetClass(classes)
    team.SetClass(self.Index, classes)
end


function META:GetClass()
    return team.GetClass(self.Index)
end


function META:AddScore(increment)
    if increment == nil then
        increment = 1
    end

    team.AddScore(self.Index, increment)
end


function META:SubScore(reduce)
    if reduce == nil then
        reduce = 1
    end

    self:AddScore(-reduce)
end


function META:SetSpawnPoint(classes)
    team.SetSpawnPoint(self.Index, classes)
end


function META:GetSpawnPoint()
    return team.GetSpawnPoint(self.Index)
end


function META:GetSpawnPoints()
    return team.GetSpawnPoints(self.Index)
end


function META:Valid()
    return team.Valid(self.Index)
end


META.IsValid = META.Valid


net.Receive("TeamMenu_Join", function(_, ply)
    if CLIENT then
        return
    end

    local team_index = net.ReadInt(32)
    local team_instance = New(team_index)

    if not ply:IsAdmin() and not team_instance:GetJoinable() then
        return
    end

    team_instance:Join(player)

    net.Start("TeamMenu_OnJoin")
    net.WriteInt(team_index,  32)
    net.Send(player)
end)


net.Receive("TeamMenu_OnJoin", function(_, player)
    if CLIENT then
        return
    end

    local team_index = net.ReadInt(32)

    hook.Run("TeamMenu_OnPlayerJoinTeam", New(team_index), LocalPlayer())
end)


net.Receive("TeamMenu_Share", function(_, player)
    if SERVER then
        local team_index = net.ReadInt(32)
        local team_is_removed = net.ReadBool()
        local team_data = net.ReadTable()

        if not Handler.Process("") then
            return
        end

        local team_instance = New(team_index)

        team_instance:SafeReplaceTable(team_data)
        team_instance:Commit()

        if team_is_removed then
            team_instance:Remove()
        end

        net.Start("TeamMenu_Share")
        net.WriteInt(team_index, 32)
        net.WriteBool(team_is_removed)
        net.Broadcast()

        return
    end

    local team_index = net.ReadInt(32)
    local team_is_removed = net.ReadBool()
    local team_instance = New(team_index)

    team_instance:Pull()

    if team_is_removed then
        team_instance:Remove()
    end
end)


if SERVER then
    hook.Add("PlayerInitialSpawn", "Uratrecom_TeamMenu_InitialShare", function(player)
        for team_index in ipairs(teams) do
            New(team_index):Share(player)
        end
    end)
end