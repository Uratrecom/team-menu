Uratrecom.Module("Uratrecom.TeamMenu.ConVars", Uratrecom.TeamMenu)


ConVars = {}


local server_flags = bit.bor(
    FCVAR_ARCHIVE,
    FCVAR_REPLICATED,
    FCVAR_NOTIFY
)

local client_flags = bit.bor(
    FCVAR_ARCHIVE,
    FCVAR_USERINFO
)


function CreateServerConVar(name, default, min, max)
    local global_name = "team_menu_sv_" .. name

    Convars[name] = CreateConVar(global_name, default, server_flags, "", min, max)
end


function CreateClientConVar(name, default, min, max)
    if not CLIENT then
        return
    end

    local global_name = "team_menu_cl_" .. name

    Convars[name] = CreateConVar(global_name, default, client_flags, "", min, max)
end


function GetConVars()
    return ConVars
end


function GetConVar(name)
    return ConVars[name]
end


function Toggle(name)
    local convar = GetConVar(name)

    if not convar then
        return
    end

    convar:SetBool(not convar:GetBool())
end


function Enable(name)
    SetBool(name, false)
end


function IsEnabled(name)
    return GetBool(name)
end


function Disable(name)
    SetBool(name, false)
end


function IsDisabled(name)
    return not IsEnabled()
end


function SetBool(name, value)
    local convar = GetConVar(name)

    if not convar then
        return
    end

    convar:SetBool(value)
end


function GetBool(name)
    local convar = GetConVar(name)

    if not convar then
        return
    end

    return convar:GetBool()
end


function SetFloat(name, value)
    local convar = GetConVar(name)

    if not convar then
        return
    end

    convar:SetFloat(value)
end


function GetFloat(name)
    local convar = GetConVar(name)

    if not convar then
        return
    end

    return convar:GetFloat()
end


function SetInt(name, value)
    local convar = GetConVar(name)

    if not convar then
        return
    end

    convar:SetInt(value)
end


function GetInt(name)
    local convar = GetConVar(name)

    if not convar then
        return
    end

    return convar:GetInt()
end


function SetString(name, value)
    local convar = GetConVar(name)

    if not convar then
        return
    end

    convar:SetString(value)
end


function GetString(name)
    local convar = GetConVar(name)

    if not convar then
        return
    end

    return convar:GetString()
end


CreateServerConVar("friendly_fire", "0", 0, 1)
CreateServerConVar("allow_create_team", "0", 0, 1)
CreateServerConVar("autosave", "0", 0, 1)
CreateServerConVar("autosave_time", "300", 0, 86400)
CreateServerConVar("handler", "AdminOnly")

CreateClientConVar("hud_show_unknown_label", "1", 0, 1)
CreateClientConVar("hud_show_enemy_label", "1", 0, 1)
CreateClientConVar("hud_show_friend_label", "1", 0, 1)
CreateClientConVar("hud_show_label", "1", 0, 1)
CreateClientConVar("hud_animate_label", "1", 0, 1)
CreateClientConVar("hud_show_no_team", "1", 0, 1)
CreateClientConVar("hud_show_my_team", "1", 0, 1)
CreateClientConVar("hud_show_player_team", "1", 0, 1)
CreateClientConVar("hud_show_entity_team", "1", 0, 1)

-- May be removed later
CreateClientConVar("hud_show_entity_relationship", "1", 0, 1)
CreateClientConVar("hud_unknown_color_red", "197", 0, 255)
CreateClientConVar("hud_unknown_color_green", "198", 0, 255)
CreateClientConVar("hud_unknown_color_blue", "86", 0, 255)
CreateClientConVar("hud_friend_color_red", "198", 0, 255)
CreateClientConVar("hud_friend_color_green", "86", 0, 255)
CreateClientConVar("hud_friend_color_blue", "86", 0, 255)
CreateClientConVar("hud_enemy_color_red", "99", 0, 255)
CreateClientConVar("hud_enemy_color_green", "198", 0, 255)
CreateClientConVar("hud_enemy_color_blue", "86", 0, 255)