local TeamMenu = Uratrecom.TeamMenu


local PANEL = {}


AccessorFunc(PANEL, "Background", "Background", FORCE_COLOR)


function PANEL:Init()
    self:SetSize(800, 600)
    self:SetBackground(Color(28, 28, 28))
end


local function MultiplyColor(color, amount)
    return Color(
        color.r * amount,
        color.g * amount,
        color.b * amount
    )
end


function PANEL:Paint(width, height)
    surface.SetDrawColor(MultiplyColor(self:GetBackground(), self:HasFocus() and 1.00 or 0.85))
    surface.DrawRect(0, 0, width, height)


    return true
end


vgui.Register(TeamMenu.PrefixId("Window"), PANEL, "DFrame")