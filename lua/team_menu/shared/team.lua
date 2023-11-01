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
    if Utils.IsPlayer(team_index) then
        team_index = team_index:Team()
    end

    if not isnumber(team_index) then
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

        return team_cache, false
    end

    local initial_creation = not team.Valid(team_index)

    team_data = Uratrecom.Get(Teams, team_index, {}, true)

    local self = setmetatable({
        Index = team_index,
        Data = team_data
    }, META)

    self:InitializeFields()

    Cache[team_index] = self

    return self, initial_creation
end


function RemoveTeam(team_index)
    New(team_index):Remove()
end


function RemoveTeams()
    for team_index in ipairs(teams) do
        RemoveTeam(team_index)
    end
end


function GetLocalTeam()
    if SERVER then
        return
    end

    return New(LocalPlayer())
end


AccessorFunc(META, "Index", "Index", FORCE_NUMBER)
AccessorFunc(META, "Data", "Data")


function META:__tostring()
    print(self.Index)
    PrintTable(self.Data)

    return ""
end


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
    return GetGlobal2String("Team." .. tostring(self.Index) .. ".Name")
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
    -- if not Handler.Process("UpdateTeam", ply, self) then
    --     return
    -- end

    if SERVER then
        self:Commit()

        print(self:GetNWName())

        net.Start("Uratrecom_TeamMenu_Share")
        net.WriteInt(self.Index, 32)

        if Utils.IsPlayer(ply) then
            net.Send(ply)
        else
            net.Broadcast()
        end

        return
    end

    net.Start("Uratrecom_TeamMenu_Share")
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
end


function META:Restore()
    Teams[self.Index] = self.Data
    Cache[self.Index] = self

    self:SetRemoved(false)
    self:SetNWRemoved(false)
end


function META:Remove()
    Cache[self.Index] = nil
    Teams[self.Index] = nil

    self:SetRemoved(true)
    self:SetNWRemoved(true)
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
            ply:SetTeam(self.Index)
        end

        return
    end

    if not Handler.Process("ChangeTeam", LocalPlayer(), GetLocalTeam(), self) then
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


net.Receive("Uratrecom_TeamMenu_Join", function(_, ply)
    if CLIENT then
        return
    end

    local team_index = net.ReadInt(32)

    if not team.Valid(team_index) then
        return
    end

    local team_instance = New(team_index)

    if not Handler.Process("ChangeTeam", ply, New(ply), team_instance) then
        return
    end

    team_instance:Join(player)
end)


net.Receive("Uratrecom_TeamMenu_Share", function(_, ply)
    if SERVER then
        local team_index = net.ReadInt(32)
        local team_is_removed = net.ReadBool()
        local team_data = net.ReadTable()
        local team_instance, team_initial_creation = New(team_index)

        if team_is_removed then
            team_instance:Remove()
        else
            team_instance:ReplaceTable(team_data)
            team_instance:Commit()    
        end

        net.Start("Uratrecom_TeamMenu_Share")
        net.WriteInt(team_index, 32)
        net.Broadcast()

        return
    end

    print("\n\n\nPULL")

    local team_index = net.ReadInt(32)
    local team_instance = New(team_index)

    if team_instance:GetNWRemoved() then
        team_instance:Remove()

        return
    end

    print(team_instance)
    team_instance:Pull()
    print(team_instance)
end)


if SERVER then
    hook.Add("PlayerInitialSpawn", "Uratrecom_TeamMenu_InitialShare", function(ply)
        -- for team_index in pairs(Teams) do
        --     if isnumber(team_index) then
        --         New(team_index):Share()
        --     end
        -- end
    end)
    hook.Add("PostGamemodeLoaded", "uyfyf", function(ply)
        local t = New(88)

        t:SetName("Gays")
        t:SetScore(-9999)
        t:Share()
    end)
end