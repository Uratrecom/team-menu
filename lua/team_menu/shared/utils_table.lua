local Utils = TeamMenu.Utils


Utils.table = Utils.table or Utils.ReferenceTable(table)


Utils.SetGlobalTable(Utils.table)


function Set(tbl, path, value)
    if not Utils.CheckArguments(tbl, path, value) then
        return
    end


    local keys = path:Split(".")


    for index, key in ipairs(keys) do
        tbl = tbl[key]


        if tbl == nil then
            return
        end


        if index == #keys - 1 then
            tbl[keys[index + 1]] = value

            return
        end
    end
end


Utils.AddArguments(Set, {
    { name = "tbl", required = true, type = "table" },
    { name = "path", required = true, type = "string" },
    { name = "value", required = false, type = "any" }
})


function Get(tbl, path)
    if not Utils.CheckArguments(tbl, path) then
        return
    end


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


Utils.AddArguments(Get, {
    { name = "tbl", required = true, type = "table" },
    { name = "path", required = true, type = "string" }
})


local insert = table.insert


function GetNumberKeys(tbl)
    if not Utils.CheckArguments(tbl) then
        return
    end


    local keys = {}


    for index in pairs(tbl) do
        if isnumber(index) then
            insert(keys, index)
        end
    end


    return keys
end


Utils.AddArguments(GetNumberKeys, {
    { name = "tbl", required = true, type = "table" }
})


local max = math.max


function MaxNumberKey(tbl)
    if not Utils.CheckArguments(tbl) then
        return
    end

	return max(unpack(Utils.table.GetNumberKeys(tbl)))
end


Utils.AddArguments(MaxNumberKey, {
    { name = "tbl", required = true, type = "table" }
})


local min = math.min


function MinNumberKey(tbl)
    if not Utils.CheckArguments(tbl) then
        return
    end

	return min(unpack(Utils.table.GetNumberKeys(tbl)))
end


Utils.AddArguments(MinNumberKey, {
    { name = "tbl", required = true, type = "table" }
})


local insert = table.insert


function MultipleInsert(tbl, data, position)
    if not Utils.CheckArguments(tbl, data, position) then
        return
    end


    for index, item in ipairs(data) do
        if position ~= nil then
            tbl[position + (index - 1)] = item
        else
            insert(tbl, item)
        end
    end

    
    return tbl
end


Utils.AddArguments(MultipleInsert, {
    { name = "tbl", required = true, type = "table" },
    { name = "data", required = true, type = "table" },
    { name = "position", required = false, type = "number" },
})


Utils.SetGlobalTable(nil)