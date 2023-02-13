TeamMenu.Utils = TeamMenu.Utils or {}


local Utils = TeamMenu.Utils


Utils.SetGlobalTable = TeamMenu.Loader.SetGlobalTable


Utils.SetGlobalTable(Utils)


local teams = team.GetAllTeams()


function SaveTeams(filename)
    if not Utils.CheckArguments(filename) then
        return
    end

    file.Write(filename, util.TableToJSON(teams))
end


Utils.AddArguments(SaveTeams, {
    { name = "filename", required = true, type = "string" }
})


function LoadTeams(filename)
    if not Utils.CheckArguments(filename) then
        return
    end


    local json = file.Read(filename, "DATA")
    local tbl = util.JSONToTable(json)


    for teamIndex, teamTable in pairs(tbl) do
        if teams[teamIndex] then
            table.CopyFromTo(teamTable, teams[teamIndex])
        else
            teams[teamIndex] = teamTable
        end
    end
end


Utils.AddArguments(LoadTeams, {
    { name = "filename", required = true, type = "string" }
})


function ReferenceTable(tbl)
    if not Utils.CheckArguments(tbl) then
        return
    end
    
    return setmetatable({}, { __index = tbl })
end


Utils.AddArguments(ReferenceTable, {
    { name = "tbl", required = true, type = "table" }
})


function Accessor(tbl, key, name, type, isRequired, isStatic)
    if not Utils.CheckArguments(tbl, key, name, type, isRequired, isStatic) then
        return
    end


    type = type == nil and "any" or type
    isRequired = isRequired == nil and true or isRequired
    isStatic = isStatic == nil and false or isStatic


    local function Setter(self, value)
        value = isStatic and self or value
        self = isStatic and tbl or self


        if not Utils.CheckArguments(self, value) then
            return
        end
 

        Utils.table.Set(self, key, value)
    end


    Utils.AddArguments(Setter, {
        { name = "self", required = true, type = "table" },
        { name = "value", required = isRequired, type = type }
    })


    tbl["Set" .. name] = Setter


    local function Getter(self)
        self = isStatic and tbl or self


        if not Utils.CheckArguments(self) then
            return
        end


        return Utils.table.Get(self, key)
    end


    Utils.AddArguments(Getter, {
        { name = "self", required = true, type = "table" }
    })


    tbl["Get" .. name] = Getter
end


Utils.AddArguments(Accessor, {
    { name = "tbl", required = true, type = "table" },
    { name = "key", required = true, type = "string" },
    { name = "name", required = true, type = "string" },
    { name = "type", required = false, type = "string" },
    { name = "isRequired", required = false, type = "boolean" },
    { name = "isStatic", required = false, type = "boolean" }
})


function IsTeam(value)
    return istable(value) and getmetatable(value) == TeamMenu.TEAM
end


function IsPlayer(value)
    return type(value) == "Player"
end


function SetGlobalVarArray(index, array)
    if not Utils.CheckArguments(index, array) then
        return
    end


    SetGlobalInt(index .. ".length", #array)


    for key, value in ipairs(array) do
        SetGlobalVar(index .. "." .. tostring(key), value)
    end
end


Utils.AddArguments(SetGlobalVarArray, {
    { name = "index", required = true, type = "string" },
    { name = "array", required = true, type = "table" }
})


local insert = table.insert


function GetGlobalVarArray(index)
    if not Utils.CheckArguments(index) then
        return
    end


    local tbl = {}


    for i=1, GetGlobalInt(index .. ".length") do
        insert(tbl, GetGlobalVar(i .. "." .. tostring(i)))
    end


    return tbl
end


Utils.AddArguments(GetGlobalVarArray, {
    {
        name = "index",
        required = true,
        type = "string",
        validator = function(argument, argumentData)
            if GetGlobalInt(argument .. ".length", -1) == -1 then
                return false, "index '" .. argument .. ".length' does not exist"
            end

            return true
        end
    }
})


-- Meta utils


Utils.SetGlobalTable(nil)


local COLOR = FindMetaTable("Color")


function COLOR:GetAverage()
    return (self.r + self.g + self.b) / 3
end


function COLOR:GetBrightness()
    return self:GetAverage() / 255
end


local PLAYER = FindMetaTable("Player")


function PLAYER:GetTeam()
    return TeamMenu.Team(self:Team())
end