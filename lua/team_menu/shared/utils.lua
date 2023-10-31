Uratrecom.Module("Uratrecom.TeamMenu.Utils", Uratrecom.TeamMenu)


function SetGlobalVarArray(index, array)
    SetGlobal2Int(index .. ".length", #array)

    for key, value in ipairs(array) do
        SetGlobal2Var(index .. "." .. tostring(key), value)
    end
end


function GetGlobalVarArray(index)
    local tbl = {}
    local length = GetGlobal2Int(index .. ".length")

    if length == 0 then
        ErrorNoHaltWithStack("Empty array? Bug?")
    end

    for i = 1, length do
        table.insert(tbl, GetGlobal2Var(i .. "." .. tostring(i)))
    end

    return tbl
end


function TableIndices(tbl)
    local indices = {}

    for index in pairs(tbl) do
        if isnumber(index) then
            table.insert(indices, index)
        end
    end

    return indices
end


function TableMinIndex(tbl)
    return math.min(unpack(TableIndices(tbl)))
end


function TableMaxIndex(tbl)
    return math.max(unpack(TableIndices(tbl)))
end


function IsPlayer(value)
    return IsEntity(value) and value:IsPlayer()
end


function IsValidPlayer(value)
    return IsPlayer(value) and IsValid(value)
end