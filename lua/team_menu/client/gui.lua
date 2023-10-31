TeamMenu.GUI = TeamMenu.GUI or {}


local Utils = TeamMenu.Utils
local GUI = TeamMenu.GUI


Utils.SetGlobalTable(GUI)


window = nil
title = "Team menu"
width = 700
height = 500
icon = "icon64/group.png"


icons = {}
icons.myTeam = Material("icon16/group.png")
icons.notJoinable = Material("icon16/delete.png")
icons.hasPassword = Material("icon16/key.png")
icons.adminOnly = Material("")


function GetIcons(self, team)
    if not Utils.CheckArguments(self, team) then
        return
    end


    local icons = {}


    if team:HasPlayer(LocalPlayer()) then
        table.insert(icons, self.icons.myTeam)
    end


    if not team:GetJoinable() then
        table.insert(icons, self.icons.notJoinable)    
    end


    if team:GetValue("password") ~= nil then
        table.insert(icons, self.icons.hasPassword)
    end


    return icons
end


Utils.AddArguments(GUI.GetIcons, {
    { name = "self", required = true, type = "table" },
    { name = "team", required = true, type = "table", validator = Utils.TeamValidator }
})


function DrawIcons(self, x, y, width, maxWidth, height, icons)
    local stick = width + 16 * #icons >= maxWidth


    surface.SetDrawColor(color_white)


    for i, icon in ipairs(icons) do
        i = i - 1


        local x = (stick and (x + maxWidth + 16 * i - 16 * #icons) or (width + 16 * i)) + x
        local y = (height / 2 - 8) + y


        surface.SetMaterial(icon)
        surface.DrawTexturedRect(x, y, 16, 16)
    end
end


local function GenerateTeamPanel(body, team, icons)
    for _, child in pairs(body:FindChildrenByName("TeamPanel")) do
        child:Remove()
    end

    local backgroundColor = Color(160, 160, 160, 100)
    local headerColor = Color(146, 146, 146)
    local foregroundColor = Color(255, 255, 255)

    local panel = body:Add("DPanel")
    panel:SetName("TeamPanel")
    panel:SetPos(258, 0)
    panel:SetSize(body:GetWide()-panel:GetX(), body:GetTall())

    function panel:Paint(w, h)
        surface.SetDrawColor(backgroundColor)
        surface.DrawRect(0, 0, w, h)
    end

    local teamName = team:GetName()
    local teamColor = team:GetColor()
    local teamScore = team:GetScore()
    local teamTotalFrags = team:TotalFrags()
    local teamTotalDeaths = team:TotalDeaths()

    local isJoinable = team:GetJoinable()
    local isMyTeam = team:HasPlayer(LocalPlayer())
    local isBright = (teamColor.r+teamColor.g+teamColor.b)/3/255 >= 0.7

    local teamNamePanel = panel:Add("DPanel")
    teamNamePanel:SetSize(panel:GetWide(), 33)

    function teamNamePanel:Paint(w, h)
        surface.SetDrawColor(teamColor)
        surface.DrawRect(0, 0, w, h)

        surface.SetFont("TeamName")

        local tw, th = surface.GetTextSize(teamName)

        surface.SetTextColor(isBright and color_black or color_white)
        surface.SetTextPos(5, h/2-th/2)
        surface.DrawText(teamName)

        DrawIcons(8, 0, tw, teamNamePanel:GetWide(), teamNamePanel:GetTall(), icons)
    end

    local teamJoinButton = teamNamePanel:Add("DButton")
    teamJoinButton:SetSize(100, 22)
    teamJoinButton:SetPos(
        teamNamePanel:GetWide()-teamJoinButton:GetWide()-5, 
        teamNamePanel:GetTall()/2-teamJoinButton:GetTall()/2
    )
    teamJoinButton:SetText(isMyTeam and "Leave" or "Join")
    teamJoinButton:SetIcon(isMyTeam and "icon16/door_in.png" or "icon16/user_add.png")
    teamJoinButton:SetDisabled(not isJoinable)

    if (not isJoinable and isMyTeam) or team:GetIndex() == TEAM_UNASSIGNED then
        teamJoinButton:SetDisabled(false)
    end

    if isMyTeam and team:GetIndex() == TEAM_UNASSIGNED then
        teamJoinButton:SetDisabled(true)
    end

    function teamJoinButton:DoClick()
        if isMyTeam then
            team:Leave()
            return
        end

        team:Join()

        GenerateTeamPanel(body, team, icons)
    end

    local teamScoreLabel = panel:Add("DLabel")
    teamScoreLabel:SetPos(5, teamNamePanel:GetY()+teamNamePanel:GetTall()+5)
    teamScoreLabel:SetWide(panel:GetWide())
    teamScoreLabel:SetFont("TeamLabel")
    teamScoreLabel:SetText("Score")

    local teamScoreValue = panel:Add("DLabel")
    teamScoreValue:SetPos(5, teamScoreLabel:GetY()+teamScoreLabel:GetTall())
    teamScoreValue:SetWide(panel:GetWide())
    teamScoreValue:SetFont("TeamLabelValue")
    teamScoreValue:SetText(tostring(teamScore))

    local teamTotalFragsLabel = panel:Add("DLabel")
    teamTotalFragsLabel:SetPos(5, teamScoreValue:GetY()+teamScoreValue:GetTall()+5)
    teamTotalFragsLabel:SetWide(panel:GetWide())
    teamTotalFragsLabel:SetFont("TeamLabel")
    teamTotalFragsLabel:SetText("Total Frags")

    local teamTotalFragsValue = panel:Add("DLabel")
    teamTotalFragsValue:SetPos(5, teamTotalFragsLabel:GetY()+teamTotalFragsLabel:GetTall())
    teamTotalFragsValue:SetWide(panel:GetWide())
    teamTotalFragsValue:SetFont("TeamLabelValue")
    teamTotalFragsValue:SetText(tostring(teamTotalFrags))

    local teamTotalDeathsLabel = panel:Add("DLabel")
    teamTotalDeathsLabel:SetPos(5, teamTotalFragsValue:GetY()+teamTotalFragsValue:GetTall()+5)
    teamTotalDeathsLabel:SetWide(panel:GetWide())
    teamTotalDeathsLabel:SetFont("TeamLabel")
    teamTotalDeathsLabel:SetText("Total Deaths")

    local teamTotalDeathsValue = panel:Add("DLabel")
    teamTotalDeathsValue:SetPos(5, teamTotalDeathsLabel:GetY()+teamTotalDeathsLabel:GetTall())
    teamTotalDeathsValue:SetWide(panel:GetWide())
    teamTotalDeathsValue:SetFont("TeamLabelValue")
    teamTotalDeathsValue:SetText(tostring(teamTotalDeaths))
end


function Initialize(self, window)
    local body = window:Add("Panel")
    body:Dock(FILL)

    local teamTitle = body:Add("TeamMenu_TeamTitle")
    teamTitle:SetTeam(Team(2))

    local btn = body:Add("DButton")

    function btn:DoClick()
        teamTitle:ToggleShowPlayerCount()
    end
    -- teamTitle:SetIcons(GetIcons(true, false, true))
    
    -- local createButton = body:Add("DButton")
    -- createButton:SetSize(126, 22)
    -- createButton:SetText("Create")
    -- createButton:SetIcon("icon16/add.png")
    -- createButton:SetDisabled(not LocalPlayer():IsAdmin())
    
    -- local refreshButton = body:Add("DButton")
    -- refreshButton:SetPos(129, 0)
    -- refreshButton:SetSize(126, 22)
    -- refreshButton:SetText("Refresh")
    -- refreshButton:SetIcon("icon16/arrow_refresh.png")

    -- local teamList = body:Add("DListView")
    -- teamList:SetPos(0, 25)
    -- teamList:SetSize(255, item.height-25)
    -- teamList:SetMultiSelect(false)
    -- teamList:AddColumn("Name", 1)
    -- teamList:AddColumn("Players", 2)

    -- local icons = {}

    -- function teamList:DoDoubleClick(_, line)
    --     GenerateTeamPanel(body, line.data, icons)
    -- end

    -- function refreshButton:DoClick()
    --     table.Empty(icons)

    --     teamList:Clear()

    --     for teamIndex in pairs(team.GetAllTeams()) do
    --         local team = Team(teamIndex)
    --         local isJoinable = team:GetJoinable()
    --         local isMyTeam = team:HasPlayer(LocalPlayer())

    --         icons[team] = GetIcons(isMyTeam, isJoinable, nil)

    --         local line = teamList:AddLine(team:GetName(), team:NumPlayers())
    --         local lineLabel = line.Columns[1]
    --         local lineText = lineLabel:GetText()

    --         line.data = team

    --         local old_Paint = line.Paint

    --         function line:Paint(w, h)
    --             old_Paint(self, w, h)

    --             surface.SetFont("DermaDefault")

    --             local x, y, wide, tall = line:GetBounds()
    --             local tw, th = surface.GetTextSize(lineText)

    --             DrawIcons(0, 0, tw+6, teamList:ColumnWidth(1), tall, icons[team])
    --         end
    --     end
    -- end

    -- refreshButton:DoClick()
end


function MakeWindow(self)
    if IsValid(self.window) then
        self.window:Center()
        self.window:MakePopup()
        return 
    end


    local window = vgui.Create("TeamMenu_Window")
    window:SetSize(self.width, self.height)
    window:SetTitle(self.title)
    window:Center()
    window:MakePopup()


    self.window = window


    self.Initialize(window)
end


concommand.Add("team_menu", function()
    GUI.MakeWindow()
end)


if engine.ActiveGamemode() != "sandbox" then
    return
end


local icon = nil


hook.Add("ContextMenuOpen", "TeamMenu_AddToContextMenu", function()
    if IsValid(icon) then
        return
    end


    local layout = g_ContextMenu:Find("DIconLayout")


    icon = layout:Add("DButton")
    icon:SetText("")
    icon:SetSize(80, 82)


    icon.Paint = nil

    
    function icon.DoClick()
        GUI.MakeWindow()
    end


    local image = icon:Add("DImage")
    image:SetImage(GUI.icon)
    image:SetSize(64, 64)
    image:Dock(TOP)
    image:DockMargin(8, 0, 8, 0)


    local label = icon:Add("DLabel")
    label:Dock(BOTTOM)
    label:SetText(GUI.title)
    label:SetContentAlignment(5)
    label:SetTextColor(color_white)
    label:SetExpensiveShadow(1, Color(0, 0, 0, 200))
end)


Utils.SetGlobalTable(nil)