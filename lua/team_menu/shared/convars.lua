local serverFlags = bit.bor(FCVAR_ARCHIVE, FCVAR_GAMEDLL, FCVAR_REPLICATED, FCVAR_NOTIFY)


-- Game rules
CreateConVar("team_menu_friendly_fire", "0", serverFlags, "", 0, 1)
CreateConVar("team_menu_allow_create_team", "0", serverFlags, "", 0, 1)
CreateConVar("team_menu_autosave", "0", serverFlags, "", 0, 1)
CreateConVar("team_menu_autosave_time", "300", serverFlags, "", 0, 86400)


-- Hud
CreateClientConVar("team_menu_hud_show_unknown_label", "1", true, false, "", 0, 1)
CreateClientConVar("team_menu_hud_show_enemy_label", "1", true, false, "", 0, 1)
CreateClientConVar("team_menu_hud_show_friend_label", "1", true, false, "", 0, 1)
CreateClientConVar("team_menu_hud_show_label", "1", true, false, "", 0, 1)
CreateClientConVar("team_menu_hud_animate_label", "1", true, false, "", 0, 1)
CreateClientConVar("team_menu_hud_show_no_team", "1", true, false, "", 0, 1)
CreateClientConVar("team_menu_hud_show_my_team", "1", true, false, "", 0, 1)
CreateClientConVar("team_menu_hud_show_player_team", "1", true, false, "", 0, 1)
CreateClientConVar("team_menu_hud_show_entity_team", "1", true, false, "", 0, 1)
CreateClientConVar("team_menu_hud_show_entity_relationship", "1", true, false, "", 0, 1)