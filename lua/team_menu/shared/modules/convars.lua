Module("TeamMenu.ConVars")


local Language = Require("TeamMenu.Language")


local CreateConVar = _G.CreateConVar
local CreateClientConVar = _G.CreateClientConVar


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


function GetConVarDescription(name, lang)
    return Language.GetPhrase(
        "team_menu.convars." .. name .. "description",
        lang or "en"
    )
end


local function ConVar(name, default, min, max)
    name = "team_menu_" .. name
    

    convars[name] = CreateConVar(
        name,
        default,
        flags,
        GetConVarDescription(name),
        min,
        max
    )


    if category ~= nil then
        categories[name] = category
    end
end


local function ClientConVar(name, default, min, max)
    name = "team_menu_" .. name


    convars[name] = CreateClientConVar(
        name,
        default,
        true,
        true,
        GetConVarDescription(name),
        min,
        max
    )


    if category ~= nil then
        categories[name] = category
    end
end


function GetConVar(name)
    return convars["team_menu_" .. name]
end


function GetConVars()
    return convars
end


function SetBool(name, value)
    return GetConVar(name):SetBool(value)
end


function GetBool(name)
    return GetConVar(name):GetBool()
end


function SetFloat(name, value)
    return GetConVar(name):SetFloat(value)
end


function GetFloat(name)
    return GetConVar(name):GetFloat()
end


function SetInt(name, value)
    return GetConVar(name):SetInt(value)
end


function GetInt(name)
    return GetConVar(name):GetInt()
end


function SetString(name, value)
    return GetConVar(name):SetString(value)
end


function GetString(name)
    return GetConVar(name):GetString()
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
ClientConVar("hud_unknown_color_red", "197", 0, 255)
ClientConVar("hud_unknown_color_green", "198", 0, 255)
ClientConVar("hud_unknown_color_blue", "86", 0, 255)
ClientConVar("hud_friend_color_red", "198", 0, 255)
ClientConVar("hud_friend_color_green", "86", 0, 255)
ClientConVar("hud_friend_color_blue", "86", 0, 255)
ClientConVar("hud_enemy_color_red", "99", 0, 255)
ClientConVar("hud_enemy_color_green", "198", 0, 255)
ClientConVar("hud_enemy_color_blue", "86", 0, 255)


Category("language")
ClientConVar("language", "auto")


Category("debug")
ClientConVar("debug", "0")