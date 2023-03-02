Module("TeamMenu.Theme")


local ConVars = Require("TeamMenu.ConVars")
local Utils = Require("TeamMenu.Utils")


local Color = _G.Color
local color_black = _G.color_black
local color_white = _G.color_white
local color_transparent = _G.color_transparent


themes = {}
META = {}


META.__index = META


function META:Set(key, value)
    self.style[key] = value
end


function META:Get(key)
    return self.style[key]
end


function META:SetDefault(key, value)
    self.style[key] = value
    self.defaults[key] = value
end


function META:GetDefault(key)
    return self.defaults[key]
end


function META:Reset(key)
    self:Set(key, self:GetDefault(key))
end


function Theme(name)
    local self = setmetatable({
        name = name,
        style = {},
        defaults = {}
    }, META)


    themes[name] = self


    return self
end


function GetCurrentThemeString()
    return ConVars.GetString("theme")
end


function GetTheme(name)
    return themes[name]
end


function GetCurrentTheme()
    return GetTheme(GetCurrentThemeString())
end


function IsDefaultTheme()
    return GetCurrentThemeString() == "default"
end


function Set(...)
    GetCurrentTheme():Set(...)
end


function Get(...)
    return GetCurrentTheme():Get(...)
end


function SetDefault(...)
    GetCurrentTheme():SetDefault(...)
end


function GetDefault(...)
    return GetCurrentTheme():GetDefault(...)
end


function Reset(...)
    GetCurrentTheme():Reset(...)
end


Theme("default")


SetDefault("window.title", Color(255, 255, 255))
SetDefault("window.title.font", "DermaDefault")
SetDefault("window.titlebar", Color(55, 63, 82))
SetDefault("window.background", Color(44, 51, 66))


SetDefault("button.font", "DermaDefault")


SetDefault("button.outline", color_transparent)
SetDefault("button.outline.size", 0)
SetDefault("button.outline.hovered", color_transparent)
SetDefault("button.outline.pressed", color_transparent)
SetDefault("button.outline.disabled", color_transparent)


SetDefault("button.foreground", color_white)
SetDefault("button.foreground.hovered", color_white)
SetDefault("button.foreground.pressed", color_white)
SetDefault("button.foreground.disabled", color_white)


SetDefault("button.background", color_black)
SetDefault("button.background.hovered", color_black)
SetDefault("button.background.pressed", color_black)
SetDefault("button.background.disabled", color_black)