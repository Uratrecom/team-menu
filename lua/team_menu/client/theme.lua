TeamMenu.Theme = TeamMenu.Theme or {}


local Utils = TeamMenu.Utils
local Theme = TeamMenu.Theme


Utils.SetGlobalTable(Theme)


style = style or {}
defaults = defaults or {}


function Set(self, key, value)
    if not Utils.CheckArguments(self, key, value) then
        return
    end

    self.style[key] = value
end


Utils.AddArguments(Set, {
    { name = "self", required = true, type = "table" },
    { name = "key", required = true, type = "string" },
    {
        name = "value",
        required = true,
        type = { "table", "boolean", "number", "string" },
        validator = Utils.ColorValidator
    }
})


function Get(self, key)
    if not Utils.CheckArguments(self, key) then
        return
    end

    return self.style[key]
end


Utils.AddArguments(Get, {
    { name = "self", required = true, type = "table" },
    { name = "key", required = true, type = "string" },
})


function SetDefault(self, key, value)
    if not Utils.CheckArguments(self, key, value) then
        return
    end

    self.style[key] = value
    self.defaults[key] = value
end


Utils.AddArguments(SetDefault, {
    { name = "self", required = true, type = "table" },
    { name = "key", required = true, type = "string" },
    {
        name = "value",
        required = true,
        type = { "table", "boolean", "number", "string" },
        validator = Utils.ColorValidator
    }
})


function GetDefault(self, key)
    if not Utils.CheckArguments(self, key) then
        return
    end

    return self.defaults[key]
end


Utils.AddArguments(GetDefault, {
    { name = "self", required = true, type = "table" },
    { name = "key", required = true, type = "string" }
})


function Reset(self, key)
    if not Utils.CheckArguments(self, key) then
        return
    end

    self:Set(key, self:GetDefault(self, key))
end


Utils.AddArguments(Reset, {
    { name = "self", required = true, type = "table" },
    { name = "key", required = true, type = "string" }
})


Utils.SetGlobalTable(nil)


-- Default theme


Theme:SetDefault("window.title", Color(255, 255, 255))
Theme:SetDefault("window.title.font", "DermaDefault")
Theme:SetDefault("window.titlebar", Color(55, 63, 82))
Theme:SetDefault("window.background", Color(44, 51, 66))


Theme:SetDefault("button.font", "DermaDefault")


Theme:SetDefault("button.outline", color_transparent)
Theme:SetDefault("button.outline.size", 0)
Theme:SetDefault("button.outline.hovered", color_transparent)
Theme:SetDefault("button.outline.pressed", color_transparent)
Theme:SetDefault("button.outline.disabled", color_transparent)


Theme:SetDefault("button.foreground", color_white)
Theme:SetDefault("button.foreground.hovered", color_white)
Theme:SetDefault("button.foreground.pressed", color_white)
Theme:SetDefault("button.foreground.disabled", color_white)


Theme:SetDefault("button.background", color_black)
Theme:SetDefault("button.background.hovered", color_black)
Theme:SetDefault("button.background.pressed", color_black)
Theme:SetDefault("button.background.disabled", color_black)