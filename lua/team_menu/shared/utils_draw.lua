local Utils = TeamMenu.Utils


Utils.draw = Utils.draw or Utils.ReferenceTable(draw)


Utils.SetGlobalTable(Utils.draw)


function RoundedRectangle(t, verticesCount, lineThickness, lineMode, x, y, width, height)    
    Utils.surface.DrawQuadraticCurve(
        verticesCount,
        lineThickness,
        lineMode,
        x,
        Clamp(Lerp(t, y, y + height), x, y + height / 2),
        x,
        y,
        Clamp(Lerp(t, x, x + width), x, x + width / 2),
        y
    )

    Utils.surface.DrawLine(
        lineThickness,
        lineMode,
        Clamp(Lerp(t, x, x + width), x, x + width / 2),
        y,
        Clamp(Lerp(1 - t, x, x + width), x + width / 2, x + width),
        y
    )

    Utils.surface.DrawQuadraticCurve(
        verticesCount,
        lineThickness,
        lineMode,
        Clamp(Lerp(1 - t, x, x + width), x + width / 2, x + width),
        y,
        x + width,
        y,
        x + width,
        Clamp(Lerp(t, y, y + height), y, y + height / 2)
    )

    Utils.surface.DrawLine(
        lineThickness,
        lineMode,
        x + width,
        Clamp(Lerp(t, y, y + height), y, y + height / 2),
        x + width,
        Clamp(Lerp(1 - t, y, y + height), y + height / 2, y + height)
    )

    Utils.surface.DrawQuadraticCurve(
        verticesCount,
        lineThickness,
        lineMode,
        x + width,
        Clamp(Lerp(1 - t, y, y + height), y + height / 2, y + height),
        x + width,
        y + height,
        Clamp(Lerp(1 - t, x, x + width), x + width / 2, x + width),
        y + height
    )

    Utils.surface.DrawLine(
        lineThickness,
        lineMode,
        Clamp(Lerp(1 - t, x, x + width), x + width / 2, x + width),
        y + height,
        Clamp(Lerp(t, x, x + width), x, x + width / 2),
        y + height
    )

    Utils.surface.DrawQuadraticCurve(
        verticesCount,
        lineThickness,
        lineMode,
        Clamp(Lerp(t, x, x + width), x, x + width / 2),
        y + height,
        x,
        y + height,
        x,
        Clamp(Lerp(1 - t, y, y + height), y + height / 2, y + height)
    )

    Utils.surface.DrawLine(
        lineThickness,
        lineMode,
        x,
        Clamp(Lerp(1 - t, y, y + height), y + height / 2, y + height),
        x,
        Clamp(Lerp(t, y, y + height), y, y + height / 2)
    )

    surface.SetDrawColor(Color(0, 0, 0, 100))
    surface.DrawRect(x, y, width, height)
end


function SimpleRoundedRectangle(t, lineThickness, x, y, width, height)    
    Utils.draw.RoundedRectable(
        t,
        32,
        lineThickness,
        LINE_MODE.INNER,
        x,
        y,
        width,
        height
    )
end


Utils.SetGlobalTable(nil)