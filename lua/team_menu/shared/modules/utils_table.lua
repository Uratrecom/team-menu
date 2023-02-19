Module("TeamMenu.Utils.Table")


local math = _G.math
local ipairs = _G.pairs
local table = _G.table
local unpack = _G.unpack
local tostring = _G.tostring
local tonumber = _G.tonumber


function SetValue(tbl, path, value)
    local keys = tostring(path):Split(".")

    for index, key in ipairs(keys) do
        key = tonumber(key, 10) ~= nil and tonumber(key, 10) or key


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


function GetValue(tbl, path, default)
    local target = tbl
    local keys = tostring(path):Split(".")

    for index, key in ipairs(keys) do
        key = tonumber(key, 10) ~= nil and tonumber(key, 10) or key


        tbl = tbl[key]


        if tbl == nil then
            if default ~= nil then
                return SetValue(target, path, default)
            end

            return
        end


        if index == #keys then
            return tbl
        end
    end
end


function GetNumberKeys(tbl)
    local keys = {}


    for index in ipairs(tbl) do
        table.insert(keys, index)
    end


    return keys
end


function MaxNumberKey(tbl)
	return math.max(unpack(GetNumberKeys(tbl)))
end


function MinNumberKey(tbl)
	return math.min(unpack(GetNumberKeys(tbl)))
end