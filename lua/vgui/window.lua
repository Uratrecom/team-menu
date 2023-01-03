local Utils = TeamMenu.Utils
local Theme = TeamMenu.Theme


local PANEL = {}


Utils.SetGlobalTable(PANEL)


function Init(self)
    self.titleBar = {}

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


--[[-----------------------------------------------------------

	Setters and getters

-----------------------------------------------------------]]--


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


--[[-----------------------------------------------------------

	Other stuff

-----------------------------------------------------------]]--


function Stylize(self)
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


function ShowCloseButton(self)
    self.btnClose:SetVisible(true)
end


function HideCloseButton(self)
    self.btnClose:SetVisible(false)
end


function ShowMinimizeButton(self)
    self.btnMinim:SetVisible(true)
end


function HideMinimizeButton(self)
    self.btnMinim:SetVisible(false)
end


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