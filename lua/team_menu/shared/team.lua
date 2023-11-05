Uratrecom.Module("Uratrecom.TeamMenu.Team", Uratrecom.TeamMenu)


if SERVER then
    util.AddNetworkString(PrefixId("Join"))
    util.AddNetworkString(PrefixId("Share"))
end


Teams = team.GetAllTeams()
AccessorFunc(self, "Teams", "Teams")

Cache = {}
AccessorFunc(self, "Cache", "Cache")

META = {}
META.__index = META
AccessorFunc(self, "META", "META")


function New(index)
    if Utils.IsPlayer(index) then
        index = index:Team()
    end

    if not isnumber(index) then
        local min_index = Utils.TableMinIndex(Teams)
        local max_index = Utils.TableMaxIndex(Teams)

        for i = min_index, max_index do
            if Teams[i] == nil then
                index = i
                break
            end
        end

        index = index == nil and max_index + 1 or index
    end

    local data = Teams[index]
    local cache = Cache[index]

    if cache then
        if cache.Data ~= data then
            Teams[index] = cache.Data
        end

        return cache, false
    end

    local initial_creation = not team.Valid(index)

    data = Uratrecom.Get(Teams, index, {}, true)

    local self = setmetatable({}, META)
    self:SetIndex(index)
    self:SetData(data)
    self:InitializeFields()

    Cache[index] = self

    return self, initial_creation
end


function RemoveTeam(index)
    New(index):Remove()
end


function RemoveTeams()
    for index in ipairs(GetTeams()) do
        RemoveTeam(index)
    end
end


function GetLocalTeam()
    if SERVER then
        return
    end

    return New(LocalPlayer())
end


function META:__tostring()
    return ("Team %i: %s"):format(self:GetIndex(), self:GetName())
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
    return GetGlobal2String("Team." .. tostring(self.Index) .. ".Name", "Undefined")
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


function META:GetNWJoinable()
    return GetGlobal2Bool("Team." .. tostring(self.Index) .. ".Joinable")
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

    if self:IsJoinable() == nil then
        self:SetJoinable(true)
    end

    if self:GetSelectableClasses() == nil then
        self:SetSelectableClasses({})
    end

    if self:GetProperties() == nil then
        self:SetProperties({})
    end

    if self:IsRemoved() == nil then
        self:SetRemoved(false)
    end
end


function META:Share(ply)
    if SERVER then
        self:Commit()

        net.Start(PrefixId("Share"))
        net.WriteInt(self.Index, 32)

        if Utils.IsPlayer(ply) then
            net.Send(ply)
        else
            net.Broadcast()
        end

        return
    end

    if not Events.CanCreateTeam(LocalPlayer(), self) and
       not Events.CanUpdateTeam(LocalPlayer(), self) and
       (not Events.CanRemoveTeam(LocalPlayer(), self) and self:IsRemoved())
    then
        return
    end

    net.Start(PrefixId("Share"))
    net.WriteInt(self.Index, 32)
    net.WriteBool(self:IsRemoved())
    net.WriteTable(self.Data)
    net.SendToServer()
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

    Events.TeamUpdated(self, false)
end


function META:Commit()
    if CLIENT then
        return
    end

    self:SetNWName(self:GetName())
    self:SetNWRemoved(self:IsRemoved())
    self:SetNWColor(self:GetColor())
    self:SetNWScore(self:GetScore())
    self:SetNWJoinable(self:IsJoinable())
    self:SetNWSelectableClasses(self:GetSelectableClasses())

    for key, value in pairs(self:GetProperties()) do
        self:SetNWProperty(key, value)
    end

    self:SetNWPropertyKeys()

    Events.TeamUpdated(self, true)
end


function META:Restore()
    Teams[self.Index] = self.Data
    Cache[self.Index] = self

    self:SetRemoved(false)
    self:SetNWRemoved(false)

    Events.TeamRestored(self)
end


function META:Remove(silent)
    Cache[self.Index] = nil
    Teams[self.Index] = nil

    self:SetRemoved(true)
    self:SetNWRemoved(true)

    if silent then
        return
    end

    Events.TeamRemoved(self)
end


function META:ReplaceTable(tbl)
    table.Empty(self.Data)
    table.Merge(self.Data, tbl)
end


function META:HasPlayer(ply)
    return ply:Team() == self.Index
end


function META:HasLocalPlayer()
    if not CLIENT then
        return false
    end

    return self:HasPlayer(LocalPlayer())
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
            local old_team = New(ply)

            ply:SetTeam(self.Index)

            Events.TeamChanged(ply, old_team, self)
        end

        return
    end

    if not Events.CanChangeTeam(LocalPlayer(), GetLocalTeam(), self) then
        return
    end

    local old_team = GetLocalTeam()

    net.Start(PrefixId("Join"))
    net.WriteInt(self.Index, 32)
    net.SendToServer()

    Events.TeamChanged(LocalPlayer(), old_team, self)
end


function META:Leave(ply)
    if SERVER then
        if not Events.CanLeaveTeam(ply, self) then
            return
        end

        New(TEAM_UNASSIGNED):Join(ply)

        Events.LeaveTeam(ply, self, New(TEAM_UNASSIGNED))

        return
    end

    if not Events.CanLeaveTeam(LocalPlayer(), self) then
        return
    end

    New(TEAM_UNASSIGNED):Join()

    Events.LeaveTeam(LocalPlayer(), self, New(TEAM_UNASSIGNED))
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


net.Receive(PrefixId("Join"), function(_, ply)
    if CLIENT then
        return
    end

    local index = net.ReadInt(32)

    if not team.Valid(index) then
        return
    end

    local team_instance = New(index)

    if not Events.CanChangeTeam(ply, New(ply), team_instance) then
        return
    end

    team_instance:Join(player)
end)


local teams_to_update = nil


if CLIENT then
    teams_to_update = {}

    hook.Add("InitPostEntity", PrefixId("UpdateTeams"), function()
        for _, data in ipairs(teams_to_update) do
            local team_instance = data.instance
            local initial_creation = data.initial_creation

            if team_instance:GetNWRemoved() then
                team_instance:Remove()
            else
                team_instance:Pull()

                Events.TeamCreated(team_instance)
            end
        end

        teams_to_update = nil
    end)
end


net.Receive(PrefixId("Share"), function(_, ply)
    if SERVER then
        local index = net.ReadInt(32)
        local is_removed = net.ReadBool()
        local data = net.ReadTable()
        local team_instance, initial_creation = New(index)

        if initial_creation and not Events.CanCreateTeam(ply, team_instance) then
            team_instance:Remove(true)

            return
        end

        if not initial_creation and not Events.CanUpdateTeam(ply, team_instance) then
            return
        end

        if not initial_creation and is_removed and not Events.CanRemoveTeam(ply, team_instance) then
            return
        end

        if is_removed then
            team_instance:Remove()
        else
            team_instance:ReplaceTable(data)
            team_instance:Commit()
        end

        if initial_creation and not is_removed then
            Events.TeamCreated(team_instance)
        else
            Events.TeamUpdated(team_instance, false)
        end

        net.Start(PrefixId("Share"))
        net.WriteInt(index, 32)
        net.SendOmit(ply)

        return
    end

    local index = net.ReadInt(32)
    local team_instance, initial_creation = New(index)

    if LocalPlayer() == NULL then
        table.insert(teams_to_update, {
            instance = team_instance,
            initial_creation = initial_creation
        })

        return
    end

    if team_instance:GetNWRemoved() then
        team_instance:Remove()

        return
    end

    team_instance:Pull()

    if initial_creation then
        Events.TeamCreated(team_instance)
    end
end)


if SERVER then
    hook.Add("PlayerInitialSpawn", PrefixId("InitialShare"), function(ply)
        for index in pairs(Teams) do
            if isnumber(index) then
                New(index):Share()
            end
        end
    end)
end


Hook.Add("TeamCreated", "Debug", function(team_instance)
    print(tostring(team_instance) .. " has been created")
end)

Hook.Add("TeamUpdated", "Debug", function(team_instance, is_network_change)
    print(tostring(team_instance) .. " has been updated " .. tostring(is_network_change))
end)


if CLIENT then
    hook.Add("InitPostEntity", "ojojojuig", function()
        local t = New(2006)
        t:SetName("G-ray")
        t:SetScore(666)
        t:Share()
    end)
end