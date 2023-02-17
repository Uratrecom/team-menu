Module("TeamMenu.Theme")


local Color = _G.Color
local color_black = _G.color_black
local color_white = _G.color_white


style = {}
defaults = {}


function Set(key, value)
    style[key] = value
end


function Get(key)
    return style[key]
end


function SetDefault(key, value)
    style[key] = value
    defaults[key] = value
end


function GetDefault(key)
    return defaults[key]
end


function Reset(key)
    Set(key, GetDefault(key))
end


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