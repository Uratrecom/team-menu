Uratrecom.Module("Uratrecom.TeamMenu.ConVars", Uratrecom.TeamMenu)


AccessorFunc(self, "ConVars", "ConVars")
SetConVars({})


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
    name = PrefixConVar("sv_" .. name)

    ConVars[name] = CreateConVar(name, default, server_flags, "", min, max)
end


function CreateClientConVar(name, default, min, max)
    name = PrefixConVar("cl_" .. name)

    ConVars[name] = CreateConVar(name, default, client_flags, "", min, max)
end


function GetConVar(name)
    return ConVars[PrefixConVar(name)]
end


function GerPlayerInfo(ply, name)
    name = PrefixConVar("cl_" .. name)

    local value = ply:GetInfo(name)
    local client_convar = ConVars[name]

    if value == nil then
        return
    end

    if client_convar and client_convar:GetMin() == 0 and client_convar:GetMax() == 1 then
        return tobool(value)
    end

    return tonumber(value) ~= nil and tonumber(value) or value
end


function AddChangeCallback(name, callback)
    cvars.AddChangeCallback(PrefixConVar(name), callback)
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