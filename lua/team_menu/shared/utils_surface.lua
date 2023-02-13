local Utils = TeamMenu.Utils


Utils.surface = Utils.surface or Utils.ReferenceTable(surface)


Utils.SetGlobalTable(Utils.surface)


local LINE_MODE = TeamMenu.LINE_MODE
local pi = math.pi
local atan2 = math.atan2
local sin = math.sin
local cos = math.cos
local insert = table.insert


function DrawLine(thickness, mode, x, y, x2, y2)
    if not Utils.CheckArguments(thickness, mode, x, y, x2, y2) then
        return
    end


    local pi = pi / 2
    local angle = atan2(y2 - y, x2 - x)
    local verticesTable = {}


    if mode == LINE_MODE.INNER then
        insert(verticesTable, { 
            x = x + thickness * cos(angle + pi),
            y = y + thickness * sin(angle + pi) 
        })


        insert(verticesTable, { 
            x = x + 0 * cos(angle - pi),
            y = y + 0 * sin(angle - pi) 
        })


        insert(verticesTable, { 
            x = x2 + 0 * cos(angle - pi),
            y = y2 + 0 * sin(angle - pi) 
        })


        insert(verticesTable, { 
            x = x2 + thickness * cos(angle + pi),
            y = y2 + thickness * sin(angle + pi) 
        })
    end


    if mode == LINE_MODE.OUTER then
        insert(verticesTable, { 
            x = x + 0 * cos(angle + pi),
            y = y + 0 * sin(angle + pi) 
        })


        insert(verticesTable, { 
            x = x + thickness * cos(angle - pi),
            y = y + thickness * sin(angle - pi) 
        })


        insert(verticesTable, { 
            x = x2 + thickness * cos(angle - pi),
            y = y2 + thickness * sin(angle - pi) 
        })


        insert(verticesTable, { 
            x = x2 + 0 * cos(angle + pi),
            y = y2 + 0 * sin(angle + pi) 
        })
    end


    if mode == LINE_MODE.BOTH then
        insert(verticesTable, { 
            x = x + thickness * cos(angle + pi),
            y = y + thickness * sin(angle + pi) 
        })


        insert(verticesTable, { 
            x = x + thickness * cos(angle - pi),
            y = y + thickness * sin(angle - pi) 
        })


        insert(verticesTable, { 
            x = x2 + thickness * cos(angle - pi),
            y = y2 + thickness * sin(angle - pi) 
        })


        insert(verticesTable, { 
            x = x2 + thickness * cos(angle + pi),
            y = y2 + thickness * sin(angle + pi) 
        })
    end


    surface.DrawPoly(verticesTable)


    return verticesTable
end


Utils.AddArguments(Utils.surface.DrawLine, {
    { name = "thickness", required = true, type = "number" },
    { name = "mode", required = true, type = "number" },
    { name = "x", required = true, type = "number" },
    { name = "y", required = true, type = "number" },
    { name = "x2", required = true, type = "number" },
    { name = "y2", required = true, type = "number" }
})


function DrawOutlinedPolygon(thickness, mode, verticesTable)
    if not Utils.CheckArguments(thickness, mode, verticesTable) then
        return
    end
    

    local previousPoint = verticesTable[#verticesTable]


    for _, point in ipairs(verticesTable) do
        Utils.surface.DrawLine(
            thickness,
            mode,
            previousPoint.x,
            previousPoint.y,
            point.x,
            point.y
        )

        previousPoint = point
    end
end


Utils.AddArguments(Utils.surface.DrawOutlinedPolygon, {
    { name = "thickness", required = true, type = "number" },
    { name = "mode", required = true, type = "number" },
    { name = "verticesTable", required = true, type = "table" }
})


function DrawQuadraticCurve(verticesCount, thickness, mode, x, y, x2, y2, x3, y3)
    if not Utils.CheckArguments(verticesCount, thickness, mode, x, y, x2, y2, x3, y3) then
        return
    end
    

    local verticesTable = Utils.math.FullQuadraticCurve(verticesCount, x, y, x2, y2, x3, y3)
    local previousPoint = verticesTable[1]


    for _, point in ipairs(verticesTable) do
        Utils.surface.DrawLine(
            thickness,
            mode,
            previousPoint.x,
            previousPoint.y,
            point.x,
            point.y
        )

        previousPoint = point
    end
end


Utils.AddArguments(Utils.surface.DrawOutlinedPolygon, {
    { name = "verticesCount", required = true, type = "number" },
    { name = "thickness", required = true, type = "number" },
    { name = "mode", required = true, type = "number" },
    { name = "x", required = true, type = "number" },
    { name = "y", required = true, type = "number" },
    { name = "x2", required = true, type = "number" },
    { name = "y2", required = true, type = "number" },
    { name = "x3", required = true, type = "number" },
    { name = "y3", required = true, type = "number" }
})


Utils.SetGlobalTable(nil)