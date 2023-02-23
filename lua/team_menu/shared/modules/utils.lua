Module("TeamMenu.Utils")


Require("TeamMenu.Utils.Table")


local ipairs = _G.ipairs
local SetGlobalInt = _G.SetGlobalInt
local GetGlobalInt = _G.GetGlobalInt
local SetGlobalVar = _G.SetGlobalVar
local GetGlobalVar = _G.GetGlobalVar
local tostring = _G.tostring
local tonumber = _G.tonumber
local tobool = _G.tobool
local Angle = _G.Angle
local string = _G.string
local table = _G.table
local type = _G.type


function SetGlobalVarArray(index, array)
    SetGlobalInt(index .. ".length", #array)

    for key, value in ipairs(array) do
        SetGlobalVar(index .. "." .. tostring(key), value)
    end
end


function GetGlobalVarArray(index)
    local tbl = {}


    for i = 1, GetGlobalInt(index .. ".length") do
        table.insert(tbl, GetGlobalVar(i .. "." .. tostring(i)))
    end


    return tbl
end


function Accessor(tbl, path, name, valueType)
    tbl["Get" .. name] = function(self)
        return Table.GetValue(self, path)
    end

    
    if valueType == "number" then
        tbl["Set" .. name] = function(self, value)
            Table.SetValue(self, path, tonumber(value))
        end

        return
    end


    if valueType == "boolean" then
        tbl["Set" .. name] = function(self, value)
            Table.SetValue(self, path, tobool(value))
        end


        tbl["Is" .. name] = tbl["Get" .. name]


        return
    end


    if valueType == "string" then
        tbl["Set" .. name] = function(self, value)
            Table.SetValue(self, path, tostring(value))
        end

        return
    end


    if valueType == "angle" then
        tbl["Set" .. name] = function(self, value)
            Table.SetValue(self, path, Angle(value))
        end

        return
    end


    if valueType == "color" then
        tbl["Set" .. name] = function(self, value)
            Table.SetValue(
                self,
                path,
                type(value) == "Vector"
                and value:ToColor()
                or string.ToColor(tostring(value)) 
            )
        end

        return
    end


    tbl["Set" .. name] = function(self, value)
        Table.SetValue(self, path, value)
    end
end