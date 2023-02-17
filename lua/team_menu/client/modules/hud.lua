Module("TeamMenu.HUD")


local Enums = Require("TeamMenu.Enums")
local Language = Require("TeamMenu.Language")
local ConVars = Require("TeamMenu.ConVars")
local Team = Require("TeamMenu.Team")


local Color = _G.Color
local hook = _G.hook
local gui = _G.gui
local ScrW = _G.ScrW
local ScrH = _G.ScrH
local Lerp = _G.Lerp
local IsValid = _G.IsValid
local LocalPlayer = _G.LocalPlayer
local surface = _G.surface
local draw = _G.draw


function GetUnknownColor()
    return Color(
        ConVars.GetInt("hud_unknown_color_red"),
        ConVars.GetInt("hud_unknown_color_green"),
        ConVars.GetInt("hud_unknown_color_blue")
    )
end


function GetFriendColor()
    return Color(
        ConVars.GetInt("hud_friend_color_red"),
        ConVars.GetInt("hud_friend_color_green"),
        ConVars.GetInt("hud_friend_color_blue")
    )
end


function GetEnemyColor()
    return Color(
        ConVars.GetInt("hud_enemy_color_red"),
        ConVars.GetInt("hud_enemy_color_green"),
        ConVars.GetInt("hud_enemy_color_blue")
    )
end


box = {
    width = 200,
    height = 22
}


label = {
    text = "",
    foreground = Color(255, 255, 255, 0),
    background = GetUnknownColor(),
    width = 0,
    height = 0
}


local mouseIsOrigin = false
local lastEntity = nil
local seeEntity = false


do
    local function func()
        mouseIsOrigin = true
    end

    hook.Add("ContextMenuOpened", "TeamMenu_OnOpenContextMenu", func)
    hook.Add("StartChat", "TeamMenu_OnOpenChat", func)
end


do
    local function func()
        mouseIsOrigin = true
    end

    hook.Add("ContextMenuClosed", "TeamMenu_OnCloseContextMenu", func)
    hook.Add("FinishChat", "TeamMenu_OnCloseChat", func)
end


function GetRelationship(player, entity)
    local playerTeam = Team(player)
    local entityTeam = Team(entity)


    if playerTeam:IsDefaultTeam() or entityTeam:IsDefaultTeam() then
        return Enums.RELATIONSHIP_TYPE.UNKNOWN
    end


    if playerTeam:HasPlayer(entity) then
        return Enums.RELATIONSHIP_TYPE.FRIEND
    end


    return Enums.RELATIONSHIP_TYPE.ENEMY
end


function IsUnknown(relationship)
    return relationship == Enums.RELATIONSHIP_TYPE.UNKNOWN
end


function IsEnemy(relationship)
    return relationship == Enums.RELATIONSHIP_TYPE.ENEMY
end


function IsFriend(relationship)
    return relationship == Enums.RELATIONSHIP_TYPE.FRIEND
end


function GetRelationshipColor(relationship)
    return IsUnknown(relationship) and GetUnknownColor() or
           IsFriend(relationship) and GetFriendColor() or
           IsEnemy(relationship) and GetEnemyColor() or nil
end


function GetRelationshipText(relationship, lang)
    return IsUnknown(relationship) and Language.GetPhrase("team_menu.hud.unknown", lang) or
           IsFriend(relationship) and Language.GetPhrase("team_menu.hud.friend", lang) or
           IsEnemy(relationship) and Language.GetPhrase("team_menu.hud.enemy", lang) or nil
end


function CanDrawRelationship(relationship)
    return IsUnknown(relationship) and ConVars.GetBool("hud_show_unknown") or
           IsFriend(relationship) and ConVars.GetBool("hud_show_friend") or
           IsEnemy(relationship) and ConVars.GetBool("hud_show_enemy")
end


function GetOriginPosition()
    return mouseIsOrigin and gui.MouseX() or ScrW() / 2, 
           mouseIsOrigin and gui.MouseY() or ScrH() / 2
end


function DrawEntityRelationship(player, entity)
    local x, y = GetOriginPosition()


    local relationship = GetRelationship(player, entity)
    local relationshipText = GetRelationshipText(relationship)
    local relationshipColor = GetRelationshipColor(relationship)


    if not CanDrawEntityRelationShip(relationship) then
        return
    end


    surface.SetFont("TargetIDSmall")


    local textWidth, textHeight = surface.GetTextSize(relationshipText)


    surface.SetDrawColor(relationshipColor)
    surface.DrawRect(
        x - self.labelWidth / 2,
        y + 78,
        self.labelWidth,
        textHeight
    )


    surface.SetTextPos(x - textWidth / 2, y - textHeight / 2 + 85)
    surface.SetTextColor(self.labelTextColor)
    surface.DrawText(relationshipText)


    if not seeEntity then
        if ConVars.GetBool("hud_animate_label") then
            self.labelWidth = Lerp(0.10, self.labelWidth, 0)
            self.labelTextColor.a = Lerp(0.10, self.labelTextColor.a, 0)
        else
            self.labelWidth = 0
            self.labelTextColor.a = 0
        end

        return
    end


    if ConVars.GetBool("hud_animate_label") then
        self.labelWidth = Lerp(0.10, self.labelWidth, textWidth + 10)
        self.labelTextColor.a = Lerp(0.10, self.labelTextColor.a, 255)
    else
        self.labelWidth = textWidth + 10
        self.labelTextColor.a = 255
    end
end


function DrawEntityTeam(player, entity)
    local x, y = GetOriginPosition()


    local entityTeam = Team(entity)
    local entityTeamName = entityTeam:GetName()
    local entityTeamColor = entityTeam:GetColor()


    if entityTeam:IsDefaultTeam() then
        entityTeamName = Language.GetPhrase("team_menu.hud.no_team")

        if not ConVars.GetBool("hud_show_no_team") then
            return
        end
    end


    surface.SetFont("TargetIDSmall")


    local textWidth, textHeight = surface.GetTextSize(entityTeamName)


    surface.SetTextPos(x - textWidth / 2, y - textHeight / 2 + 70)
    surface.SetTextColor(entityTeamColor)
    surface.DrawText(entityTeamName)
end


function DrawPlayerTeam(player)
    local playerTeam = Team(player)
    local playerTeamName = playerTeam:GetName()
    local playerTeamColor = playerTeam:GetColor()


    if playerTeam:IsDefaultTeam() then
        playerTeamName = Language.GetPhrase("team_menu.hud.no_team")

        if not ConVars.GetBool("hud_show_no_team") then
            return
        end
    end


    draw.RoundedBox(
        6,
        25,
        ScrH() - 100,
        self.boxWidth,
        self.boxHeight,
        Color(0, 0, 0, 100)
    )


    surface.SetFont("Default")


    local textWidth, textHeight = surface.GetTextSize(playerTeamName)


    surface.SetTextColor(playerTeamColor)
    surface.SetTextPos(
        25 + box.width / 2 - textWidth / 2, 
        ScrH() - 100 + box.height / 2 - textHeight / 2
    )
    surface.DrawText(playerTeamName)
end


hook.Add("HUDPaint", "TeamMenu_DrawHUD", function()
    local player = LocalPlayer()
    local trace = player:GetEyeTrace()
    local entity = trace.Entity


    if IsValid(entity) and entity:IsPlayer() then
        if entity ~= lastEntity then
            label.width = 0
            label.foreground.a = 0
        end

        lastEntity = entity
        seeEntity = true
    else
        seeEntity = false
    end


    if ConVars.GetBool("hud_show_player_team") then
        DrawPlayerTeam(player)
    end


    if ConVars.GetBool("hud_show_entity_team") and lastEntity and seeEntity then
        DrawEntityTeam(player, lastEntity)
    end


    if ConVars.GetBool("hud_show_entity_relationship") and lastEntity then
        DrawEntityRelationship(player, lastEntity)
    end
end)