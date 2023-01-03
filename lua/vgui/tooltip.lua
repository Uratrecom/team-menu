local delay = GetConVar("tooltip_delay")

local PANEL = {}

local backgroundColor = Color(44, 55, 90)

function PANEL:Init()
	self:SetDrawOnTop(true)
	self:SetText("")
	self:SetFont("Default")
    self:SetColor(color_white)
    self:SetAlpha(0)
    self:AlphaTo(255, 0.9, 0, function() end)

    self.DeleteContentsOnClose = false
    self.offsetXMax = 100
    self.offsetX = self.offsetXMax
    self.hide = false

    local x, y = input.GetCursorPos()

    self.mouseX = x
    self.mouseY = y
end

function PANEL:SetContents(panel, delete)
	panel:SetParent(self)

	self.Contents = panel
	self.DeleteContentsOnClose = delete or false
	self.Contents:SizeToContents()
	self.Contents:SetVisible(false)
	self:InvalidateLayout(true)
end

function PANEL:PerformLayout()
	if IsValid(self.Contents) then
		self:SetWide(self.Contents:GetWide()+8)
		self:SetTall(self.Contents:GetTall()+8)
		self.Contents:SetPos(4, 4)
		self.Contents:SetVisible(true)

        return
    end

    local w, h = self:GetContentSize()
    self:SetSize(w+8, h+6)
    self:SetContentAlignment(5)
end

function PANEL:PositionTooltip()
	if not IsValid(self.TargetPanel) then
		self:Close()
		return
	end

	self:InvalidateLayout(true)

    local x = self.mouseX
    local y = self.mouseY
	local w, h = self:GetSize()
	local lx, ly = self.TargetPanel:LocalToScreen(0, 0)

    self.offsetX = Lerp(0.03, self.offsetX, self.hide and self.offsetXMax or 0)

    x = x+(self.hide and -self.offsetX or self.offsetX)
	y = y-50

	y = math.min(y, ly-h*1.5)
    y = y < 2 and 2 or y

	self:SetPos(math.Clamp(x-w*0.5, 0, ScrW()-self:GetWide()), 
                math.Clamp(y, 0, ScrH()-self:GetTall()))
end

function PANEL:Paint(w, h)
    local font = self:GetFont()
    local text = self:GetText()
    local color = self:GetColor()

	self:PositionTooltip()

    surface.SetDrawColor(backgroundColor)
    surface.DrawRect(0, 0, w, h)

    surface.SetFont(font)
    surface.SetTextColor(color)

    local tw, th = surface.GetTextSize(text)

    surface.SetTextPos(w/2-tw/2, h/2-th/2)
    surface.DrawText(text)

    return true
end

function PANEL:OpenForPanel(panel)
	self.TargetPanel = panel
	self:PositionTooltip()

	if delay:GetFloat() > 0 then
		self:SetVisible(false)

		timer.Simple(delay:GetFloat(), function()
			if not IsValid(self) or not IsValid(panel) then 
                return 
            end

			self:PositionTooltip()
			self:SetVisible(true)
		end)
	end
end

function PANEL:Close()
    self.hide = true

    self:AlphaTo(0, 0.3, 0, function()
    	if not self.DeleteContentsOnClose and IsValid(self.Contents) then
            self.Contents:SetVisible(false)
            self.Contents:SetParent(nil)
        end
    
        self:Remove()
    end)
end

vgui.Register("TeamMenu_ToolTip", PANEL, "DLabel")