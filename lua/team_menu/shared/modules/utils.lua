Module("TeamMenu.Utils")


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


function SafeGetTable(tbl, path)
    local value = GetTableValue(tbl, path)


    if value == nil then
        return SetTableValue(tbl, path, {})
    end


    return value
end