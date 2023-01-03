TeamMenu.Theme = TeamMenu.Theme or {}

local Utils = TeamMenu.Utils
local Theme = TeamMenu.Theme

Theme.style = Theme.style or {}
Theme.defaults = Theme.defaults or {}

function Theme:Set(key, value)
    if not Utils.CheckArguments(self, key, value) then
        return
    end

    self.style[key] = value
end

Utils.AddArguments(Theme.Set, {
    { name = "self", required = true, type = "table" },
    { name = "key", required = true, type = "string" },
    {
        name = "value",
        required = true,
        type = { "table", "boolean", "number" },
        validator = Utils.ColorValidator
    }
})

function Theme:Get(key)
    if not Utils.CheckArguments(self, key, value) then
        return
    end

    return self.style[key]
end

Utils.AddArguments(Theme.Get, {
    { name = "self", required = true, type = "table" },
    { name = "key", required = true, type = "string" },
})

function Theme:SetDefault(key, value)
    if not Utils.CheckArguments(self, key, value) then
        return
    end

    self.style[key] = value
    self.defaults[key] = value
end

Utils.AddArguments(Theme.SetDefault, {
    { name = "self", required = true, type = "table" },
    { name = "key", required = true, type = "string" },
    {
        name = "value",
        required = true,
        type = { "table", "boolean", "number" },
        validator = Utils.ColorValidator
    }
})

function Theme:GetDefault(key)
    if not Utils.CheckArguments(self, key) then
        return
    end

    return self.defaults[key]
end

Utils.AddArguments(Theme.GetDefault, {
    { name = "self", required = true, type = "table" },
    { name = "key", required = true, type = "string" }
})

function Theme:Reset(key)
    if not Utils.CheckArguments(self, key) then
        return
    end

    self:Set(key, self:GetDefault(self, key))
end

Utils.AddArguments(Theme.Reset, {
    { name = "self", required = true, type = "table" },
    { name = "key", required = true, type = "string" }
})


-- @param pattern pattern to search
-- @description the little function to search for keys by pattern
function Theme:Find(pattern)
    if not Utils.CheckArguments(self, pattern) then
        return
    end

    local result = {}

    for key, value in pairs(self.style) do
        if key:match(pattern) ~= nil then
            result[key] = value
        end
    end

    return result
end

Utils.AddArguments(Theme.Find, {
    { name = "self", required = true, type = "table" },
    { name = "pattern", required = true, type = "string" }
})


--[[-----------------------------------------------------------

	Default theme

-----------------------------------------------------------]]--


Theme:SetDefault("window.title", Color(55, 63, 82))
Theme:SetDefault("window.background", Color(44, 51, 66))

Theme:SetDefault("button.outline.idle", Color(44, 51, 66))
Theme:SetDefault("button.outline.hovered", Color(44, 51, 66))
Theme:SetDefault("button.outline.pressed", Color(44, 51, 66))
Theme:SetDefault("button.outline.disabled", Color(44, 51, 66))

Theme:SetDefault("button.foreground.idle", Color(44, 51, 66))
Theme:SetDefault("button.foreground.hovered", Color(44, 51, 66))
Theme:SetDefault("button.foreground.pressed", Color(44, 51, 66))
Theme:SetDefault("button.foreground.disabled", Color(44, 51, 66))

Theme:SetDefault("button.background.idle", Color(44, 51, 66))
Theme:SetDefault("button.background.hovered", Color(44, 51, 66))
Theme:SetDefault("button.background.pressed", Color(44, 51, 66))
Theme:SetDefault("button.background.disabled", Color(44, 51, 66))
