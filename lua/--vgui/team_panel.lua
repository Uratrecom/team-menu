local PANEL = {}

function PANEL:Init()
    self.labels = {}


end

function PANEL:PerformLayout(w, h)
    for _, child in pairs(self:GetChildren()) do
        child:SetWide(w)
    end
end

function PANEL:SetTeam(value)
    if not IsTeam(value) then
        ErrorNoHaltWithStack("Bad argument #1 to 'SetTeam' (team class expected, got " .. type(value) .. ")")
        return
    end

    self.team = value
    self:Update()
end

function PANEL:GetTeam(value)
    return self.team
end

function PANEL:SetIcons(value)
    if not istable(value) and type(value) ~= nil then
        ErrorNoHaltWithStack("Bad argument #1 to 'SetIcons' (table or nil expected, got " .. type(value) .. ")")
        return
    end

    self.icons = value
    self:Update()
end

function PANEL:GetIcons(value)
    return self.icons
end

function PANEL:Update()
    local team = self.team

    self.nameValue:SetText(team:GetName())
    self.scoreValue:SetText(tostring(team:GetScore()))
    self.totalFragsValue:SetText(tostring(team:TotalFrags()))
    self.totalDeathsValue:SetText(tostring(team:TotalDeaths()))

    self.memberList:Clear()
    
    for _, ply in team:GetPlayers() do
        self.memberList:AddLine(ply:GetName())
    end
end

vgui.Register("TeamMenu_TeamPanel", PANEL, "Panel")