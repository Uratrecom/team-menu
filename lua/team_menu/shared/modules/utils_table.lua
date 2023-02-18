Module("TeamMenu.Utils.Table")


local math = _G.math
local ipairs = _G.pairs
local table = _G.table


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