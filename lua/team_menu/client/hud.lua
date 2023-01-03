-- TeamMenu.HUD = TeamMenu.HUD or {}


-- local Utils = TeamMenu.Utils
-- local Language = TeamMenu.Language
-- local HUD = TeamMenu.HUD


-- TeamMenu.RELATIONSHIP_TYPE = Utils.Enum({
--     "UNKNOWN",
--     "ENEMY",
--     "FRIEND"
-- })


-- local RELATIONSHIP_TYPE = TeamMenu.RELATIONSHIP_TYPE


-- TeamMenu.RELATIONSHIP_COLOR = Utils.Enum({
--     UNKNOWN = Color(197, 198, 86),
--     ENEMY = Color(198, 86, 86),
--     FRIEND = Color(99, 198, 86)
-- })


-- local RELATIONSHIP_COLOR = TeamMenu.RELATIONSHIP_COLOR


-- Utils.SetGlobalTable(HUD)


-- box = {}
-- box.width = 200
-- box.height = 22


-- label = {}
-- label.text = ""
-- label.foreground = Color(255, 255, 255, 0)
-- label.background = RELATIONSHIP_COLOR.UNKNOWN
-- label.width = 0
-- label.height = 0


-- local mouseIsOrigin = false
-- local lastEntity = nil
-- local seeEntity = false


-- local showUnknownLabel = GetConVar("team_menu_hud_show_unknown_label")
-- local showEnemyLabel = GetConVar("team_menu_hud_show_enemy_label")
-- local showFriendLabel = GetConVar("team_menu_hud_show_friend_label")
-- local showLabel = GetConVar("team_menu_hud_show_label")
-- local animateLabel = GetConVar("team_menu_hud_animate_label")
-- local showPlayerTeam = GetConVar("team_menu_hud_show_player_team")
-- local showEntityTeam = GetConVar("team_menu_hud_show_entity_team")
-- local showNoTeam = GetConVar("team_menu_hud_show_no_team")
-- local showEntityRelationship = GetConVar("team_menu_hud_show_entity_relationship")


-- hook.Add("InitPostEntity", "TeamMenu_HUD_Initialize", function()
--     HUD:Initialize()
-- end)


-- function Initialize(self)
--     Utils.hook.MultipleAdd({
--         function()
--             mouseIsOrigin = true
--         end,

--         { event = "ContextMenuOpened", id = "TeamMenu_OnOpenContextMenu" },
--         { event = "StartChat", id = "TeamMenu_OnOpenChat" },

--         function()
--             mouseIsOrigin = false
--         end,

--         { event = "ContextMenuClosed", id = "TeamMenu_OnCloseContextMenu" },
--         { event = "FinishChat", id = "TeamMenu_OnCloseChat" },
--     })

--     hook.Add("HUDPaint", "TeamMenu_DrawHUD", function()
--         local trace = LocalPlayer():GetEyeTrace()
--         local entity = trace.Entity
    
--         if IsValid(entity) and entity:IsPlayer() then
--             if entity ~= lastEntity then
--                 self.labelWidth = 0
--                 self.labelTextColor.a = 0
--             end

--             lastEntity = entity
--             seeEntity = true
--         else
--             seeEntity = false
--         end

--         if showPlayerTeam:GetBool() then
--             self:DrawPlayerTeam(LocalPlayer())
--         end

--         if showEntityTeam:GetBool() then
--             if lastEntity and seeEntity then
--                 self:DrawEntityTeam(LocalPlayer(), lastEntity)
--             end
--         end

--         if showEntityRelationship:GetBool() then
--             if lastEntity then
--                 self:DrawEntityRelationship(LocalPlayer(), lastEntity)
--             end
--         end
--     end)
-- end

-- function HUD:GetRelationship(player, entity)
--     local playerTeam = player:GetTeam()
--     local entityTeam = entity:GetTeam()

--     if playerTeam:IsDefaultTeam() or entityTeam:IsDefaultTeam() then
--         return RELATIONSHIP_TYPE.UNKNOWN
--     end

--     if playerTeam:HasPlayer(entity) then
--         return RELATIONSHIP_TYPE.FRIEND
--     end

--     return RELATIONSHIP_TYPE.ENEMY
-- end

-- function HUD:IsUnknown(relationship)
--     return relationship == RELATIONSHIP_TYPE.UNKNOWN
-- end

-- function HUD:IsEnemy(relationship)
--     return relationship == RELATIONSHIP.ENEMY
-- end

-- function HUD:IsFriend(relationship)
--     return relationship == RELATIONSHIP.FRIEND
-- end

-- function HUD:GetRelationshipColor(relationship)
--     if self:IsUnknown(relationship) then
--         return RELATIONSHIP_COLOR.UNKNOWN
--     end

--     if self:IsEnemy(relationship) then
--         return RELATIONSHIP_COLOR.ENEMY
--     end

--     if self:IsFriend(relationship) then
--         return RELATIONSHIP_COLOR.FRIEND
--     end
-- end

-- function HUD:GetRelationshipText(relationship)
--     if self:IsUnknown(relationship) then
--         return Language.GetPhrase("team_menu.hud.unknown")
--     end

--     if self:IsEnemy(relationship) then
--         return Language.GetPhrase("team_menu.hud.enemy")
--     end

--     if self:IsFriend(relationship) then
--         return Language.GetPhrase("team_menu.hud.friend")
--     end
-- end

-- function HUD:CanDrawEntityRelationShip(relationship)
--     if self:IsUnknown(relationship) and not showUnknownLabel:GetBool() then
--         return false
--     end

--     if self:IsEnemy(relationship) and not showEnemyLabel:GetBool() then
--         return false
--     end

--     if self:IsFriend(relationship) and not showFriendLabel:GetBool() then
--         return false
--     end

--     return true
-- end

-- function HUD:GetOriginPosition()
--     local x = self.mouseIsOrigin and gui.MouseX() or ScrW() / 2
--     local y = self.mouseIsOrigin and gui.MouseY() or ScrH() / 2

--     return x, y
-- end

-- function HUD:DrawEntityRelationship(player, entity)
--     local x, y = self:GetOriginPosition()

--     local relationship = self:GetRelationship(player, entity)
--     local relationshipText = self:GetRelationshipText(relationship)
--     local relationshipColor = self:GetRelationshipColor(relationship)

--     if not self:CanDrawEntityRelationShip(relationship) then
--         return
--     end

--     surface.SetFont("TargetIDSmall")
    
--     local textWidth, textHeight = surface.GetTextSize(relationshipText)

--     if not showEntityTeam:GetBool() then
--         y = y - textHeight
--     end

--     surface.SetDrawColor(relationshipColor)
--     surface.DrawRect(
--         x - self.labelWidth / 2,
--         y + 78,
--         self.labelWidth,
--         textHeight
--     )

--     surface.SetTextPos(x - textWidth / 2, y - textHeight / 2 + 85)
--     surface.SetTextColor(self.labelTextColor)
--     surface.DrawText(relationshipText)

--     if not self.seeEntity then
--         if animateLabel:GetBool() then
--             self.labelWidth = Lerp(0.10, self.labelWidth, 0)
--             self.labelTextColor.a = Lerp(0.10, self.labelTextColor.a, 0)
--         else
--             self.labelWidth = 0
--             self.labelTextColor.a = 0
--         end

--         return
--     end

--     if animateLabel:GetBool() then
--         self.labelWidth = Lerp(0.10, self.labelWidth, textWidth + 10)
--         self.labelTextColor.a = Lerp(0.10, self.labelTextColor.a, 255)
--     else
--         self.labelWidth = textWidth + 10
--         self.labelTextColor.a = 255
--     end
-- end

-- function HUD:DrawEntityTeam(player, entity)
--     local x, y = self:GetOriginPosition()
    
--     local entityTeam = entity:GetTeam()
--     local entityTeamName = entityTeam:GetName()
--     local entityTeamColor = entityTeam:GetColor()

--     if entityTeam:IsDefaultTeam() then
--         entityTeamName = Language.GetPhrase("team_menu.hud.no_team")
--     end

--     if entityTeam:IsDefaultTeam() and not showNoTeam:GetBool() then
--         return
--     end

--     surface.SetFont("TargetIDSmall")

--     local textWidth, textHeight = surface.GetTextSize(entityTeamName)

--     surface.SetTextPos(x - textWidth / 2, y - textHeight / 2 + 70)
--     surface.SetTextColor(entityTeamColor)
--     surface.DrawText(entityTeamName)
-- end

-- function HUD:DrawPlayerTeam(player)
--     local playerTeam = player:GetTeam()
--     local playerTeamName = playerTeam:GetName()
--     local playerTeamColor = playerTeam:GetColor()

--     if playerTeam:IsDefaultTeam() then
--         playerTeamName = Language.GetPhrase("team_menu.hud.no_team")
--     end

--     if playerTeam:IsDefaultTeam() and not showNoTeam:GetBool() then
--         return
--     end

--     draw.RoundedBox(
--         6,
--         25,
--         ScrH() - 100,
--         self.boxWidth,
--         self.boxHeight,
--         Color(0, 0, 0, 100)
--     )

--     surface.SetFont("Default")

--     local textWidth, textHeight = surface.GetTextSize(playerTeamName)

--     surface.SetTextColor(playerTeamColor)
--     surface.SetTextPos(
--         25 + self.boxWidth / 2 - textWidth / 2, 
--         ScrH() - 100 + self.boxHeight / 2 - textHeight / 2
--     )
--     surface.DrawText(playerTeamName)
-- end


-- Utils.SetGlobalTable(nil)