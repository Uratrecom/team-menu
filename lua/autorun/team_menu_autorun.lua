TeamMenu = TeamMenu or {}


include("team_menu/loader.lua")


local Loader = TeamMenu.Loader


Loader.Debug(true)
Loader.MainFolder("team_menu")
Loader.Priority("shared/enums.lua", 1)
Loader.Priority("shared/convars.lua", 1)
Loader.Priority("shared/utils.lua", 2)
Loader.Priority("shared/utils_*.lua", 3)
Loader.Priority("shared/language.lua", 4)
Loader.Load()