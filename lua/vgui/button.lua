local Utils = TeamMenu.Utils
local Theme = TeamMenu.Theme

local PANEL = {}

TeamMenu.ICON_ALIGN = Utils.Enum {
    "LEFT",
    "BEFORE_TEXT",
    "AFTER_TEXT",
    "RIGHT"
}

local ICON_ALIGN = TeamMenu.ICON_ALIGN

function PANEL:Init()
    self:SetContentAlignment(5)


    self.label = self:Add("DLabel")


    self.foreground = {}
    self.background = {}
    self.outline = {}
    self.round = {}
    self.icon = {}
    self.icon.size = {}
    self.icon.offset = {}

    
    self:SetDefaultFont()
    self:SetText("Text")


    self:SetRadius(0)
    self:SetRoundTopLeft(true)
    self:SetRoundTopRight(true)
    self:SetRoundBottomLeft(true)
    self:SetRoundBottomRight(true)
    
    
    self:SetForeground(color_white)
    self:SetForegroundHovered(Color(100, 100, 100))
    self:SetForegroundPressed(Color(61, 61, 61))
    self:SetForegroundDisabled(Color(255, 255, 255, 100))


    self:SetBackground(Color(50, 58, 76))
    self:SetBackgroundHovered(Color(177, 59, 59))
    self:SetBackgroundPressed(Color(247, 88, 88))
    self:SetBackgroundDisabled(Color(50, 58, 76))


    self:HideOutline()


    self:SetIconAlign(ICON_ALIGN.RIGHT)
    self:SetIconOffset(0, 0)


    self:SetDisabled(false)
end


-- foreground setters/getters


function PANEL:SetForeground(color)
    if not Utils.CheckArguments(color) then
        return
    end

    self.foreground.idle = color
end


Utils.AddArguments(PANEL.SetForeground, {
    { name = "color", required = true, type = "table", validator = Utils.ColorValidator }
})


function PANEL:GetForeground()
    return self.foreground.idle
end


function PANEL:SetForegroundHovered(color)
    if not Utils.CheckArguments(color) then
        return
    end

    self.foreground.hovered = color
end


Utils.AddArguments(PANEL.SetForegroundHovered, {
    { name = "color", required = true, type = "table", validator = Utils.ColorValidator }
})


function PANEL:GetForegroundHovered()
    return self.foreground.hovered
end


function PANEL:SetForegroundPressed(color)
    if not Utils.CheckArguments(color) then
        return
    end

    self.foreground.pressed = color
end


Utils.AddArguments(PANEL.SetForegroundPressed, {
    { name = "color", required = true, type = "table", validator = Utils.ColorValidator }
})


function PANEL:GetForegroundPressed()
    return self.foreground.pressed
end


function PANEL:SetForegroundDisabled(color)
    if not Utils.CheckArguments(color) then
        return
    end

    self.foreground.disabled = color
end


Utils.AddArguments(PANEL.SetForegroundDisabled, {
    { name = "color", required = true, type = "table", validator = Utils.ColorValidator }
})


function PANEL:GetForegroundDisabled()
    return self.foreground.disabled
end


-- background setters/getters


function PANEL:SetBackground(color)
    if not Utils.CheckArguments(color) then
        return
    end

    self.background.idle = color
end


Utils.AddArguments(PANEL.SetBackground, {
    { name = "color", required = true, type = "table", validator = Utils.ColorValidator }
})


function PANEL:GetBackground()
    return self.background.idle
end


function PANEL:SetBackground(color)
    if not Utils.CheckArguments(color) then
        return
    end

    self.background.hover = color
end


Utils.AddArguments(PANEL.SetBackground, {
    { name = "color", required = true, type = "table", validator = Utils.ColorValidator }
})


function PANEL:GetBackgroundHovered()
    return self.background.hover
end


function PANEL:SetBackgroundPressed(color)
    if not Utils.CheckArguments(color) then
        return
    end

    self.background.pressed = color
end


Utils.AddArguments(PANEL.SetBackgroundPressed, {
    { name = "color", required = true, type = "table", validator = Utils.ColorValidator }
})


function PANEL:GetBackgroundPressed()
    return self.background.pressed
end


function PANEL:SetBackgroundDisabled(color)
    if not Utils.CheckArguments(color) then
        return
    end

    self.background.disabled = color
end


Utils.AddArguments(PANEL.SetBackgroundDisabled, {
    { name = "color", required = true, type = "table", validator = Utils.ColorValidator }
})


function PANEL:GetBackgroundDisabled()
    return self.background.disabled
end


-- outline setters/getters


function PANEL:SetOutline(color)
    if not Utils.CheckArguments(color) then
        return
    end

    self.outline.idle = color
end


Utils.AddArguments(PANEL.SetOutline, {
    { name = "color", required = true, type = "table", validator = Utils.ColorValidator }
})


function PANEL:GetOutline()
    return self.outline.idle
end


function PANEL:SetOutlineHovered(color)
    self.outline.hovered = color
end

function PANEL:GetOutlineHovered()
    return self.outline.hovered
end

function PANEL:SetOutlinePressed(color)
    self.outline.pressed = color
end

function PANEL:GetOutlinePressed()
    return self.outline.pressed
end

function PANEL:SetOutlineDisabled(color)
    self.outline.disabled = color
end

function PANEL:GetOutlineDisabled()
    return self.outline.disabled
end

function PANEL:SetOutlineSize(color)
    self.outline.size = color
end

function PANEL:GetOutlineSize()
    return self.outline.size
end

function PANEL:HideOutline()
    self:SetOutlineSize(0)
    self:SetOutline(color_transparent)
    self:SetOutlineHovered(color_transparent)
    self:SetOutlinePressed(color_transparent)
    self:SetOutlineDisabled(color_transparent)
end


-- radius setter/getter

function PANEL:SetRadius(radius)
    self.radius = radius
end

function PANEL:GetRadius()
    return self.radius
end


-- font setter/getter

function PANEL:SetFont(font)
    self.font = font
end

function PANEL:GetFont()
    return self.font
end

function PANEL:SetDefaultFont()
    self:SetFont("DermaDefault")
end


-- disable setter/getter/is/toggle

function PANEL:SetDisabled(isDisabled)
    self.disabled = isDisabled
end

function PANEL:GetDisabled()
    return self.disabled
end

function PANEL:IsDisabled()
    return self.disabled
end

function PANEL:ToggleDisabled()
    self:SetDisabled(not self:GetDisabled())
end


-- text setter/getter

function PANEL:SetText(text)
    self.text = text
end

function PANEL:GetText()
    return self.text
end


-- rounds setters/getters

function PANEL:SetRoundTopLeft(round)
    self.round.topLeft = round
end

function PANEL:GetRoundTopLeft()
    return self.round.topLeft
end

function PANEL:SetRoundTopRight(round)
    self.round.topRight = round
end

function PANEL:GetRoundTopRight()
    return self.round.topRight
end

function PANEL:SetRoundBottomLeft(round)
    self.round.bottomLeft = round
end

function PANEL:GetRoundBottomLeft()
    return self.round.bottomLeft
end

function PANEL:SetRoundBottomRight(round)
    self.round.bottomRight = round
end

function PANEL:GetRoundBottomRight()
    return self.round.bottomRight
end


-- Icon setter/getter

function PANEL:SetIcon(material)
    self.icon.material = material
end

function PANEL:GetIcon()
    return self.icon.material
end


-- Icon align setter/getter

function PANEL:SetIconAlign(align)
    self.icon.align = align
end

function PANEL:GetIconAlign()
    return self.icon.align
end


-- Icon padding setter/getter

function PANEL:SetIconOffsetX(x)
    self.icon.offset.x = x
end

function PANEL:GetIconOffsetX()
    return self.icon.offset.x
end

function PANEL:SetIconOffsetY(y)
    self.icon.offset.y = y
end

function PANEL:GetIconOffsetY()
    return self.icon.offset.y
end

function PANEL:SetIconOffset(x, y)
    if isnumber(x) then
        self.icon.offset.x = x
    end

    if isnumber(y) then
        self.icon.offset.y = y
    end
end

function PANEL:GetIconOffset()
    return self.icon.offset.x, self.icon.offset.y
end


-- Icon size setter/getter

function PANEL:SetIconSize(width, height)
    if isnumber(width) and not isnumber(height) then
        self.icon.size.width = width
        self.icon.size.height = width
        return
    end

    self.icon.size.width = width
    self.icon.size.height = height
end

function PANEL:GetIconSize()
    return self.icon.size.width, self.icon.size.height
end

function PANEL:SetIconWidth(width)
    self.icon.size.width = width
end

function PANEL:GetIconWidth()
    return self.icon.size.width
end

function PANEL:SetIconHeight(height)
    self.icon.size.height = height
end

function PANEL:GetIconHeight()
    return self.icon.size.height
end


-- Events

function PANEL:DoClick() end
function PANEL:DoDoubleClick() end

function PANEL:OnMousePressed(button)
    if self:IsHovered() and button == MOUSE_LEFT then
        self:DoClick()

        if self.clickTime and SysTime() - self.clickTime <= 0.5 then
            self:DoDoubleClick()
            self.clickTime = nil

            return
        end 

        self.clickTime = SysTime()
    end
end

function PANEL:IsPressed()
    return self:IsHovered() and input.IsMouseDown(MOUSE_LEFT)
end

function PANEL:Paint(width, height)
    local outlineColor = self:GetOutline()
    local foregroundColor = self:GetForeground()
    local backgroundColor = self:GetBackground()

    if self:IsHovered() then
        outlineColor = self:GetOutlineHovered()
        foregroundColor = self:GetForegroundHovered()
        backgroundColor = self:GetBackgroundHovered()
    end

    if self:IsPressed() then
        outlineColor = self:GetOutlinePressed()
        foregroundColor = self:GetForegroundPressed()
        backgroundColor = self:GetBackgroundPressed()
    end

    if self:IsDisabled() then
        outlineColor = self:GetOutlineDisabled()
        foregroundColor = self:GetForegroundDisabled()
        backgroundColor = self:GetBackgroundDisabled()
    end

    local outlineSize = self:GetOutlineSize()
    local radius = self:GetRadius()
    local roundTopLeft = self:GetRoundTopLeft()
    local roundTopRight = self:GetRoundTopRight()
    local roundBottomLeft = self:GetRoundBottomLeft()
    local roundBottomRight = self:GetRoundBottomRight()

    if radius > 0 then
        draw.RoundedBoxEx(
            radius,
            0,
            0,
            width,
            height,
            outlineColor,
            roundTopLeft,
            roundTopRight,
            roundBottomLeft,
            roundBottomRight
        )

        local centerX, centerY, width, height = Utils.math.Center(
            0,
            0,
            width,
            height,
            width - outlineSize,
            height - outlineSize
        )

        draw.RoundedBoxEx(
            radius,
            centerX,
            centerY,
            width,
            height,
            backgroundColor,
            roundTopLeft,
            roundTopRight,
            roundBottomLeft,
            roundBottomRight
        )
    else
        surface.SetDrawColor(backgroundColor)
        surface.DrawRect(0, 0, width, height)
    end

    local text = self:GetText() or ""

    surface.SetFont(self:GetFont())

    local textWidth, textHeight = surface.GetTextSize(text)

    surface.SetTextColor(foregroundColor)
    surface.SetTextPos(Utils.math.Center(0, 0, width, height, textWidth, textHeight))
    surface.DrawText(text)

    local icon = self:GetIcon()
    local iconForcedWidth, iconForcedHeight = self:GetIconSize()
    local iconAlign = self:GetIconAlign()
    local iconOffsetX, iconOffsetY = self:GetIconOffset()

    if icon then
        surface.SetDrawColor(color_white)
        surface.SetMaterial(icon)

        local iconWidth = isnumber(iconForcedWidth) and iconForcedWidth or icon:Width()
        local iconHeight = isnumber(iconForcedHeight) and iconForcedHeight or icon:Height()

        if iconAlign == ICON_ALIGN.LEFT then
            surface.DrawTexturedRect(
                5 + iconOffsetX,
                height / 2 - iconHeight / 2 + iconOffsetY,
                iconWidth,
                iconHeight
            )
        end

        if iconAlign == ICON_ALIGN.BEFORE_TEXT and 
           width / 2 + textWidth / 2 - iconWidth - 5 >= 0
        then
            surface.DrawTexturedRect(
                width / 2 - textWidth / 2 - iconWidth - 5 + iconOffsetX,
                height / 2 - iconHeight / 2 + iconOffsetY,
                iconWidth,
                iconHeight
            )
        end

        if iconAlign == ICON_ALIGN.AFTER_TEXT and 
           width / 2 + textWidth / 2 + iconWidth + 5 <= width
        then
            surface.DrawTexturedRect(
                width / 2 + textWidth / 2 + 5 + iconOffsetX,
                height / 2 - iconHeight / 2 + iconOffsetY,
                iconWidth,
                iconHeight
            )
        end

        if iconAlign == ICON_ALIGN.RIGHT then
            surface.DrawTexturedRect(
                width - iconWidth - 5 + iconOffsetX,
                height / 2 - iconHeight / 2 + iconOffsetY,
                iconWidth,
                iconHeight
            )
        end
    end

    if radius <= 0 then
        surface.SetDrawColor(outlineColor)
        surface.DrawOutlinedRect(0, 0, width, height, outlineSize)
    end

    return true
end

vgui.Register("TeamMenu_Button", PANEL, "Panel")