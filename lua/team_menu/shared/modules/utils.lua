Module("TeamMenu.Utils")


Require("TeamMenu.Utils.Table")


local ipairs = _G.ipairs
local SetGlobalInt = _G.SetGlobalInt
local GetGlobalInt = _G.GetGlobalInt
local SetGlobalVar = _G.SetGlobalVar
local GetGlobalVar = _G.GetGlobalVar
local tostring = _G.tostring
local table = _G.table


-- Fuck DRY design pattern
function SetTableValue(tbl, path, value)
    local keys = path:Split(".")

    for index, key in ipairs(keys) do
        if index == #keys then
            tbl[key] = value

            return value
        end


        if tbl[key] == nil then
            tbl[key] = {}
        end


        tbl = tbl[key]
    end
end


function GetTableValue(tbl, path)
    local keys = path:Split(".")


    for index, key in ipairs(keys) do
        tbl = tbl[key]


        if tbl == nil then
            return
        end


        if index == #keys then
            return tbl
        end
    end
end


function SafeGetTableValue(tbl, path, default)
    local value = GetTableValue(tbl, path)


    if value == nil then
        return SetTableValue(tbl, path, default)
    end


    return value
end


function SafeGetTable(tbl, path)
    return SafeGetTableValue(tbl, path, {})
end


function SetGlobalVarArray(index, array)
    SetGlobalInt(index .. ".length", #array)


    for key, value in ipairs(array) do
        SetGlobalVar(index .. "." .. tostring(key), value)
    end
end


function GetGlobalVarArray(index)
    local tbl = {}


    for i=1, GetGlobalInt(index .. ".length") do
        table.insert(tbl, GetGlobalVar(i .. "." .. tostring(i)))
    end


    return tbl
end