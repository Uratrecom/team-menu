Module("TeamMenu.Utils")


Require("TeamMenu.Utils.Table")


local ipairs = _G.ipairs
local SetGlobalInt = _G.SetGlobalInt
local GetGlobalInt = _G.GetGlobalInt
local SetGlobalVar = _G.SetGlobalVar
local GetGlobalVar = _G.GetGlobalVar
local tostring = _G.tostring
local table = _G.table


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