Module("TeamMenu.Configurator")


local vgui = GetGlobal("vgui")


-- local Utils = Require("TeamMenu.Utils")
-- local Language = Require("TeamMenu.Language")


presets = {}


function CreatePreset()
    -- todo
end


function RemovePreset()
    -- todo
end


function LoadPresets()
    
end


function SavePresets()
    
end


function GetPresets()
    return presets
end


function Configurator()
    local window = vgui.Create("TeamMenu_Window")
    window:SetTitle(Language.GetPhrase("team_menu.configurator.title"))


    local body = window:GetBody()
end