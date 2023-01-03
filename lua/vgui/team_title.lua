surface.CreateFont("TeamMenu_TeamTitle", {
	font = "Roboto Light",
	size = 20,
	weight = 500,
	antialias = true
})

local Utils = TeamMenu.Utils
local GUI = TeamMenu.GUI
local PANEL = {}

function PANEL:Init()
    self:SetWide(300)
    self:SetTall(33)
    self:InvalidateLayout()

    self.title = self:Add("DLabel")
    self.title:SetX(5)
    self.title:SetFont("TeamMenu_TeamTitle")

    self.iconPanel = self:Add("Panel")
    self.iconPanel:SetWide(48)

    self.playerCount = self:Add("DLabel")
    self.playerCount:SetWide(33)
    self.playerCount:SetFont("TeamMenu_TeamTitle")
    self.playerCount:SetVisible(true)
end

function PANEL:PerformLayout(width, height)
    if self:GetShowPlayerCount() then
        self.title:SetWide(width-self.playerCount:GetWide()-10)
    else
        self.title:SetWide(width-10)
    end

    self.title:SetTall(height)
    self.playerCount:SetTall(height)
    self.playerCount:SetX(width-self.playerCount:GetWide())
end

function PANEL:Paint(w, h)
    local team = self.team

    if not team then
        return
    end

    local teamColor = team:GetColor()

    surface.SetDrawColor(teamColor)
    surface.DrawRect(0, 0, w, h)

    TeamMenu_GUI:DrawIcons(0, 0, width, width, height, self.icons)

    -- surface.SetFont("TeamTitle")

    -- local cW = surface.GetTextSize("A")
    -- local tw, th = surface.GetTextSize(teamName)

    -- surface.SetTextColor(isBright and color_black or color_white)
    -- surface.SetTextPos(5, h/2-th/2)
    -- surface.DrawText(teamName)

    -- if not self.icons then
    --     return
    -- end

    -- self:DrawIcons(8, 0, tw)
end

function PANEL:SetTeam(value)
    if not CheckArguments(SET_TEAM_ARGUMENTS, value) then
        return
    end

    self.team = value

    local teamName = self.team:GetName()
    local teamColor = self.team:GetColor()
    local teamPlayerCount = self.team:NumPlayers()
    
    local isBright = teamColor:GetBrightness() >= 0.7
    local color = isBright and color_black or color_white

    self.title:SetText(teamName)
    self.title:SetColor(color)
    self.playerCount:SetText(tostring(teamPlayerCount))
    self.playerCount:SetColor(color)
end

function PANEL:GetTeam()
    return self.team
end

function PANEL:SetShowPlayerCount(value)
    if not CheckArguments("auto", value) then
        return
    end

    self.playerCount:SetVisible(value)
    self:InvalidateLayout()
end

function PANEL:GetShowPlayerCount()
    return self.playerCount:IsVisible()
end

function PANEL:ToggleShowPlayerCount()
    self:SetShowPlayerCount(not self:GetShowPlayerCount())
end

function PANEL:SetIcons(value)
    if not CheckArguments(SET_TEAM_ARGUMENTS, value) then
        return
    end

    self.icons = value
end

function PANEL:GetIcons()
    return self.icons
end

vgui.Register("TeamMenu_TeamTitle", PANEL, "Panel")