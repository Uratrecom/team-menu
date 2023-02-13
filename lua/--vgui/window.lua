local Utils = TeamMenu.Utils
local Theme = TeamMenu.Theme


local PANEL = {}


Utils.SetGlobalTable(PANEL)


function Init(self)
    self.titleBar = {}
    self.background = {}


    self.btnMinim:Remove()
    self.btnMinim = self:Add("TeamMenu_Button")
    self.btnMinim:SetText("▬")


    self.btnMaxim:Remove()
    self.btnMaxim = self:Add("TeamMenu_Button")
    self.btnMaxim:SetText("☐")


    self.btnClose:Remove()
    self.btnClose = self:Add("TeamMenu_Button")
    self.btnClose:SetText("X")


    function self.btnClose.DoClick()
        self:Close()
    end


    self:Stylize()


    self:SetTitleBarHeight(24)
end


-- Setters and getters


-- Title bar height setter/getter


function SetTitleBarHeight(self, height)
    self.titleBar.height = height
end


function GetTitleBarHeight(self)
    return self.titleBar.height
end


-- Title bar color setter/getter


function SetTitleBar(self, color)
    self.titleBar.color = color
end


function GetTitleBar(self)
    return self.titleBar.color
end


-- Background setter/getter


function SetBackground(self, color)
    self.background.color = color
end


function GetBackground(self)
    return self.background.color
end


-- Title font setter/getter


function SetTitleFont(self, font)
    self.lblTitle:SetFont(font)
end


function GetTitleFont(self)
    return self.lblTitle:GetFont()
end


-- Title color setter/getter


function SetTitleColor(self, color)
    self.lblTitle:SetColor(color)
end


function GetTitleColor(self)
    return self.lblTitle:GetColor()
end


-- Utils


function Stylize(self)
    self:SetTitleColor(Theme:Get("window.title"))
    self:SetTitleFont(Theme:Get("window.title.font"))
    self:SetTitleBar(Theme:Get("window.titlebar"))
    self:SetBackground(Theme:Get("window.background"))
end


function GetBody(self)
    if not self.body then
        self.body = self:Add("Panel")
        self.body:Dock(FILL)
    end

    return self.body
end


-- Minimize Button


function ShowMinimizeButton(self)
    self.btnMinim:SetVisible(true)
end


function HideMinimizeButton(self)
    self.btnMinim:SetVisible(false)
end


-- Maximize Button


function ShowMaximizeButton(self)
    self.btnMaxim:SetVisible(true)
end


function HideMaximizeButton(self)
    self.btnMaxim:SetVisible(false)
end


-- Close Button


function ShowCloseButton(self)
    self.btnClose:SetVisible(true)
end


function HideCloseButton(self)
    self.btnClose:SetVisible(false)
end


-- All buttons


function ShowButtons(self)
    self:ShowMinimizeButton()
    self:ShowMaximizeButton()
    self:ShowCloseButton()
end


function HideButtons(self)
    self:HideMinimizeButton()
    self:HideMaximizeButton()
    self:HideCloseButton()
end


-- Events


function PerformLayout(self)
	local titlePush = 0


	if IsValid(self.imgIcon) then
		self.imgIcon:SetPos(5, 5)
		self.imgIcon:SetSize(16, 16)
		titlePush = 16
	end


	self.btnClose:SetPos(self:GetWide() - 31, 0)
	self.btnClose:SetSize(31, 24 )


	self.btnMaxim:SetPos(self:GetWide() - 31 * 2, 0)
	self.btnMaxim:SetSize(31, 24)


	self.btnMinim:SetPos(self:GetWide() - 31 * 3, 0)
	self.btnMinim:SetSize(31, 24)


	self.lblTitle:SetPos(8 + titlePush, 2)
	self.lblTitle:SetSize(self:GetWide() - 25 - titlePush, 20)


    return true
end


function Paint(self, width, height)
    surface.SetDrawColor(self:GetBackground())
    surface.DrawRect(0, 0, width, height)


    surface.SetDrawColor(self:GetTitleBar())
    surface.DrawRect(0, 0, width, self:GetTitleBarHeight())


    return true
end


Utils.SetGlobalTable(nil)


vgui.Register("TeamMenu_Window", PANEL, "DFrame")