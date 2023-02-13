local Utils = TeamMenu.Utils


Utils.math = Utils.math or Utils.ReferenceTable(math)


Utils.SetGlobalTable(Utils.math)


function Center(x, y, width, height, width2, height2)
    if not Utils.CheckArguments(x, y, width, height, width2, height2) then
        return
    end

    return width / 2 - width2 / 2 + x, 
           height / 2 - height2 / 2 + y, 
           width2, 
           height2
end


Utils.AddArguments(Center, {
    { name = "x", required = true, type = "number" },
    { name = "y", required = true, type = "number" },
    { name = "width", required = true, type = "number" },
    { name = "height", required = true, type = "number" },
    { name = "width2", required = true, type = "number" },
    { name = "height2", required = true, type = "number" }
})


local Round = math.Round
local concat = table.concat
local QuadraticCurve_cache = {}


function QuadraticCurve(t, x, y, x2, y2, x3, y3)
    if not Utils.CheckArguments(t, x, y, x2, y2, x3, y3) then
        return
    end


    x = Round(x)
    y = Round(y)
    x2 = Round(x2)
    y2 = Round(y2)
    x3 = Round(x3)
    y3 = Round(y3)


    local cacheKey = concat({ t, x, y, x2, y2, x3, y3 }, " ")
    local cacheValue = QuadraticCurve_cache[cacheKey]


    if cacheValue then
        return cacheValue.x, cacheValue.y
    end


    local value = (1 - t) ^ 2


    x = x * value
    y = y * value


    value = 2 * (1 - t) * t


    x2 = x2 * value
    y2 = y2 * value


    value = t ^ 2
    

    x3 = x3 * value
    y3 = y3 * value


    x = x + x2 + x3
    y = y + y2 + y3


    QuadraticCurve_cache[cacheKey] = { x = x, y = y }
    
    
    return x, y
end


Utils.AddArguments(QuadraticCurve, {
    { name = "t", required = true, type = "number" },
    { name = "x", required = true, type = "number" },
    { name = "y", required = true, type = "number" },
    { name = "x2", required = true, type = "number" },
    { name = "y2", required = true, type = "number" },
    { name = "x3", required = true, type = "number" },
    { name = "y3", required = true, type = "number" }
})


local concat = table.concat
local insert = table.insert
local FullQuadraticCurve_cache = {}


function FullQuadraticCurve(verticesCount, x, y, x2, y2, x3, y3)
    if not Utils.CheckArguments(verticesCount, x, y, x2, y2, x3, y3) then
        return
    end


    local cacheKey = concat({ verticesCount, x, y, x2, y2, x3, y3 }, " ")
    local cacheValue = FullQuadraticCurve_cache[cacheKey]


    if cacheValue then
        return cacheValue
    end


    local verticesTable = {}


    for t=0, 1, 1/verticesCount do
        local x, y = Utils.math.QuadraticCurve(t, x, y, x2, y2, x3, y3)

        insert(verticesTable, { x = x, y = y })
    end


    FullQuadraticCurve_cache[cacheKey] = verticesTable


    return verticesTable
end


Utils.AddArguments(FullQuadraticCurve, {
    { name = "verticesCount", required = true, type = "number" },
    { name = "x", required = true, type = "number" },
    { name = "y", required = true, type = "number" },
    { name = "x2", required = true, type = "number" },
    { name = "y2", required = true, type = "number" },
    { name = "x3", required = true, type = "number" },
    { name = "y3", required = true, type = "number" }
})


Utils.SetGlobalTable(nil)