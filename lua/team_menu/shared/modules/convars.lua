Module("TeamMenu.ConVars")


local Language = Require("TeamMenu.Language")


local flags = _G.bit.bor(
    _G.FCVAR_ARCHIVE,
    _G.FCVAR_GAMEDLL,
    _G.FCVAR_REPLICATED,
    _G.FCVAR_NOTIFY
)


convars = {}
categories = {}


local category = nil


local function Category(name)
    category = name
end


local function ConVar(name, default, min, max)
    name = "team_menu_" .. name
    
    convars[name] = _G.CreateConVar(
        name,
        default,
        flags,
        [[Language.GetPhrase("team_menu.convars." .. name, "en")]],
        min,
        max
    )

    if category ~= nil then
        categories[name] = category
    end
end


local function ClientConVar(name, default, min, max)
    name = "team_menu_" .. name

    convars[name] = _G.CreateClientConVar(
        name,
        default,
        true,
        true,
        [[Language.GetPhrase("team_menu.convars." .. name, "en")]],
        min,
        max
    )


    if category ~= nil then
        categories[name] = category
    end
end


function Get(name)
    return convars["team_menu_" .. name]
end


function GetBool(name)
    return GetConVar(name):GetBool()
end


function GetFloat(name)
    return GetConVar(name):GetFloat()
end


function GetInt(name)
    return GetConVar(name):GetInt()
end


function GetString(name)
    return GetConVar(name):GetString()
end


function GetConVars()
    return convars
end


Category("server")
ConVar("friendly_fire", "0", 0, 1)
ConVar("allow_create_team", "0", 0, 1)
ConVar("autosave", "0", 0, 1)
ConVar("autosave_time", "300", 0, 86400)


Category("hud")
ClientConVar("hud_show_unknown_label", "1", 0, 1)
ClientConVar("hud_show_enemy_label", "1", 0, 1)
ClientConVar("hud_show_friend_label", "1", 0, 1)
ClientConVar("hud_show_label", "1", 0, 1)
ClientConVar("hud_animate_label", "1", 0, 1)
ClientConVar("hud_show_no_team", "1", 0, 1)
ClientConVar("hud_show_my_team", "1", 0, 1)
ClientConVar("hud_show_player_team", "1", 0, 1)
ClientConVar("hud_show_entity_team", "1", 0, 1)
ClientConVar("hud_show_entity_relationship", "1", 0, 1)


Category("language")
ClientConVar("language", "auto")


Category("debug")
ClientConVar("debug", "0")