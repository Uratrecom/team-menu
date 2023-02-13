-- TODO: Add arguments check


local Utils = TeamMenu.Utils
local Theme = TeamMenu.Theme
local ICON_ALIGN = TeamMenu.ICON_ALIGN


local PANEL = {}


Utils.SetGlobalTable(PANEL)


Utils.Accessor(PANEL, "useDefaultPaint", "UseDefaultPaint", "boolean")


Utils.Accessor(PANEL, "disabled", "Disabled", "boolean")


Utils.Accessor(PANEL, "foreground.idle", "Foreground", "color")
Utils.Accessor(PANEL, "foreground.hovered", "ForegroundHovered", "color")
Utils.Accessor(PANEL, "foreground.pressed", "ForegroundPressed", "color")
Utils.Accessor(PANEL, "foreground.disabled", "ForegroundDisabled", "color")


Utils.Accessor(PANEL, "background.idle", "Background", "color")
Utils.Accessor(PANEL, "background.hovered", "BackgroundHovered", "color")
Utils.Accessor(PANEL, "background.pressed", "BackgroundPressed", "color")
Utils.Accessor(PANEL, "background.disabled", "BackgroundDisabled", "color")


Utils.Accessor(PANEL, "outline.idle", "Outline", "color")
Utils.Accessor(PANEL, "outline.size", "OutlineSize", "number")
Utils.Accessor(PANEL, "outline.hovered", "OutlineHovered", "color")
Utils.Accessor(PANEL, "outline.pressed", "OutlinePressed", "color")
Utils.Accessor(PANEL, "outline.disabled", "OutlineDisabled", "color")


Utils.Accessor(PANEL, "radius", "Radius", "number")


Utils.Accessor(PANEL, "round.topLeft", "RoundTopLeft", "boolean")
Utils.Accessor(PANEL, "round.topRight", "RoundTopRight", "boolean")
Utils.Accessor(PANEL, "round.bottomLeft", "RoundBottomLeft", "boolean")
Utils.Accessor(PANEL, "round.bottomRight", "RoundBottomRight", "boolean")


Utils.Accessor(PANEL, "icon.material", "Icon", "material")
Utils.Accessor(PANEL, "icon.offset.x", "IconOffsetX", "number")
Utils.Accessor(PANEL, "icon.offset.y", "IconOffsetY", "number")
Utils.Accessor(PANEL, "icon.size.width", "IconWidth", "number")
Utils.Accessor(PANEL, "icon.size.height", "IconHeight", "number")
Utils.Accessor(PANEL, "icon.align", "IconAlign", "number")


function Init(self)
    self.label = self:Add("DLabel")

    
    self:InvalidateLayout()


    self.foreground = {}
    self.background = {}
    self.outline = {}
    self.round = {}
    self.icon = {}
    self.icon.offset = {}
    self.icon.size = {}


    self:SetFont("DermaDefault")
    self:SetText("Text")


    self:SetRadius(0)
    self:SetRound(true, true, true, true)
    

    self:HideOutline()


    self:Stylize()


    self:SetIconAlign(ICON_ALIGN.RIGHT)
    self:SetIconOffset(0, 0)


    self:SetDisabled(false)
end


function HideOutline(self)
    if not Utils.CheckArguments(self) then
        return
    end

    self:SetOutline(color_transparent)
    self:SetOutlineSize(0)
    self:SetOutlineHovered(color_transparent)
    self:SetOutlinePressed(color_transparent)
    self:SetOutlineDisabled(color_transparent)
end


Utils.AddArguments(HideOutline, {
    { name = "self", required = true, type = "table" }
})


function SetUseDefaultStyle(self, use)
    if not Utils.CheckArguments(self, use) then
        return
    end


    self.useDefaultStyle = use


    if use then
        self.label:SetVisible(false)

        return
    end


    self.label:SetVisible(true)
end


Utils.AddArguments(SetUseDefaultStyle, {
    { name = "self", required = true, type = "table" },
    { name = "use", required = true, type = "boolean" }
})


function SetFont(self, font)
    if not Utils.CheckArguments(self, font) then
        return
    end

    self.label:SetFont(font)
end


Utils.AddArguments(SetFont, {
    { name = "self", required = true, type = "table" },
    { name = "font", required = true, type = "string" }
})


function GetFont(self)
    if not Utils.CheckArguments(self) then
        return
    end

    return self.label:GetFont()
end


Utils.AddArguments(GetFont, {
    { name = "self", required = true, type = "table" }
})


function IsDisabled(self)
    if not Utils.CheckArguments(self) then
        return
    end

    return self.disabled
end


Utils.AddArguments(IsDisabled, {
    { name = "self", required = true, type = "table" }
})


function ToggleDisabled(self)
    if not Utils.CheckArguments(self) then
        return
    end

    self:SetDisabled(not self:GetDisabled())
end


Utils.AddArguments(ToggleDisabled, {
    { name = "self", required = true, type = "table" }
})


function SetText(self, text)
    if not Utils.CheckArguments(self, text) then
        return
    end

    self.label:SetText(text)
end


Utils.AddArguments(SetText, {
    { name = "self", required = true, type = "table" },
    { name = "font", required = true, type = "string" }
})


function GetText(self)
    if not Utils.CheckArguments(self) then
        return
    end

    return self.label:GetText()
end


Utils.AddArguments(GetText, {
    { name = "self", required = true, type = "table" }
})


function SetRound(self, topLeft, topRight, bottomLeft, bottomRight)
    if not Utils.CheckArguments(self, topLeft, topRight, bottomLeft, bottomRight) then
        return
    end


    if topLeft ~= nil then
        self:SetRoundTopLeft(topLeft)
    end


    if topRight ~= nil then
        self:SetRoundTopRight(topRight)
    end


    if bottomLeft ~= nil then
        self:SetRoundBottomLeft(bottomLeft)
    end


    if bottomRight ~= nil then
        self:SetRoundBottomRight(bottomRight)
    end
end


Utils.AddArguments(SetRound, {
    { name = "self", required = true, type = "table" },
    { name = "topLeft", required = false, type = "boolean" },
    { name = "topRight", required = false, type = "boolean" },
    { name = "bottomLeft", required = false, type = "boolean" },
    { name = "bottomRight", required = false, type = "boolean" }
})


function GetRound(self)
    if not Utils.CheckArguments(self) then
        return
    end

    return self:GetRoundTopLeft(),
           self:GetRoundTopRight(),
           self:GetRoundBottomLeft(),
           self:GetRoundBottomRight()
end


Utils.AddArguments(GetRound, {
    { name = "self", required = true, type = "table" }
})


function SetIconOffset(self, x, y)
    if not Utils.CheckArguments(self, x, y) then
        return
    end


    if x ~= nil then
        self:SetIconOffsetX(x)
    end


    if y ~= nil then
        self:SetIconOffsetY(y)
    end
end


Utils.AddArguments(SetIconOffset, {
    { name = "self", required = true, type = "table" },
    { name = "x", required = false, type = "number" },
    { name = "y", required = false, type = "number" }
})


function GetIconOffset(self)
    if not Utils.CheckArguments(self) then
        return
    end

    return self:GetIconOffsetX(), self:GetIconOffsetY()
end


Utils.AddArguments(GetIconOffset, {
    { name = "self", required = true, type = "table" }
})


function SetIconSize(self, width, height)
    if not Utils.CheckArguments(self, width, height) then
        return
    end


    if width ~= nil and height == nil then
        self:SetIconWidth(width)
        self:SetIconHeight(width)

        return
    end


    self:SetIconWidth(width)
    self:SetIconHeight(height)
end


Utils.AddArguments(SetIconSize, {
    { name = "self", required = true, type = "table" },
    { name = "width", required = true, type = "number" },
    { name = "height", required = false, type = "number" }
})


function GetIconSize(self)
    if not Utils.CheckArguments(self) then
        return
    end

    return self.icon.size.width, self.icon.size.height
end


Utils.AddArguments(GetIconSize, {
    { name = "self", required = true, type = "table" }    
})


function Stylize(self)
    self:SetFont(Theme:Get("button.font"))


    self:SetOutline(Theme:Get("button.outline"))
    self:SetOutlineSize(Theme:Get("button.outline.size"))
    self:SetOutlineHovered(Theme:Get("button.outline.hovered"))
    self:SetOutlinePressed(Theme:Get("button.outline.pressed"))
    self:SetOutlineDisabled(Theme:Get("button.outline.disabled"))


    self:SetForeground(Theme:Get("button.foreground"))
    self:SetForegroundHovered(Theme:Get("button.foreground.hovered"))
    self:SetForegroundPressed(Theme:Get("button.foreground.pressed"))
    self:SetForegroundDisabled(Theme:Get("button.foreground.disabled"))


    self:SetBackground(Theme:Get("button.background"))
    self:SetBackgroundHovered(Theme:Get("button.background.hovered"))
    self:SetBackgroundPressed(Theme:Get("button.background.pressed"))
    self:SetBackgroundDisabled(Theme:Get("button.background.disabled"))
end


-- Events


function DoClick() end
function DoDoubleClick() end


function PerformLayout(self, width, height)
    self.label:SetTall(height)
end


function OnMousePressed(self, button)
    if self:IsHovered() and button == MOUSE_LEFT then
        if self.DoClick then
            self:DoClick()
        end


        if self.clickTime and SysTime() - self.clickTime <= 0.5 then
            if self.DoDoubleClick then
                self:DoDoubleClick()
            end


            self.clickTime = nil


            return
        end


        self.clickTime = SysTime()
    end
end


function Paint(self, width, height)
    if self:GetUseDefaultStyle() then
        return false
    end


    local outlineColor = self:GetOutline()
    local foregroundColor = self:GetForeground()
    local backgroundColor = self:GetBackground()


    if self:IsHovered() then
        outlineColor = self:GetOutlineHovered()
        foregroundColor = self:GetForegroundHovered()
        backgroundColor = self:GetBackgroundHovered()
    end


    if self:IsDown() then
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
    local roundTopLeft,
          roundTopRight,
          roundBottomLeft,
          roundBottomRight = self:GetRound()


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


    self.label:SetColor(foregroundColor)


    local icon = self:GetIcon()
    local iconForcedWidth, iconForcedHeight = self:GetIconSize()
    local iconAlign = self:GetIconAlign()
    local iconOffsetX, iconOffsetY = self:GetIconOffset()


    local text = self:GetText()


    surface.SetFont(self:GetFont())


    local textWidth, textHeight = surface.GetTextSize(text)


    self.label:SetWide(textWidth)
    self.label:SetX(width / 2 - textWidth / 2)


    if icon then
        surface.SetDrawColor(color_white)
        surface.SetMaterial(icon)


        local iconWidth = iconForcedWidth ~= nil and iconForcedWidth or icon:Width()
        local iconHeight = iconForcedHeight ~= nil and iconForcedHeight or icon:Height()


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


Utils.SetGlobalTable(nil)


vgui.Register("TeamMenu_Button", PANEL, "Panel")