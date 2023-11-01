-- Module("TeamMenu.GUI")


-- local hook = _G.hook
-- local Material = _G.Material
-- local table = _G.table
-- local LocalPlayer = _G.LocalPlayer
-- local IsValid = _G.IsValid
-- local vgui = _G.vgui
-- local concommand = _G.concommand
-- local BOTTOM = _G.BOTTOM
-- local TOP = _G.TOP
-- local color_white = _G.color_white
-- local Color = _G.Color


-- lastWindow = nil
-- title = "Team menu"
-- width = 700
-- height = 500
-- icon = "icon64/group.png"


-- icons = {}
-- icons.myTeam = Material("icon16/group.png")
-- icons.notJoinable = Material("icon16/delete.png")
-- icons.hasPassword = Material("icon16/key.png")
-- icons.adminOnly = Material("")


-- function GetIcons(team)
--     local iconsTable = {}


--     if team:HasPlayer(LocalPlayer()) then
--         table.insert(iconsTable, icons.myTeam)
--     end


--     if not team:GetJoinable() then
--         table.insert(iconsTable, icons.notJoinable)    
--     end


--     if team:GetProperty("password") ~= nil then
--         table.insert(iconsTable, icons.hasPassword)
--     end


--     if team:GetProperty("admin_only") then
--         table.insert(iconsTable, icons.adminOnly)
--     end


--     return iconsTable
-- end


-- function Initialize(window)
--     print("todo initialize")
-- end


-- function MakeWindow()
--     if IsValid(lastWindow) then
--         lastWindow:Center()
--         lastWindow:MakePopup()

--         return 
--     end


--     local window = vgui.Create("TeamMenu_Window")
--     window:SetSize(width, height)
--     window:SetTitle(title)
--     window:Center()
--     window:MakePopup()


--     -- lastWindow = window


--     Initialize(window)
-- end


-- concommand.Add("team_menu", function()
--     MakeWindow()
-- end)


-- local created = false


-- hook.Add("ContextMenuOpen", "TeamMenu_AddToContextMenu", function()
--     if created then
--         return
--     end


--     created = true


--     local layout = _G.g_ContextMenu:Find("DIconLayout")


--     local iconButton = layout:Add("DButton")
--     iconButton:SetText("")
--     iconButton:SetSize(80, 82)


--     iconButton.Paint = nil


--     function iconButton.DoClick()
--         MakeWindow()
--     end


--     local image = iconButton:Add("DImage")
--     image:SetImage(iconButton)
--     image:SetSize(64, 64)
--     image:Dock(TOP)
--     image:DockMargin(8, 0, 8, 0)


--     local label = iconButton:Add("DLabel")
--     label:Dock(BOTTOM)
--     label:SetText(title)
--     label:SetContentAlignment(5)
--     label:SetTextColor(color_white)
--     label:SetExpensiveShadow(1, Color(0, 0, 0, 200))
-- end)