TeamMenu = TeamMenu or {}


AddCSLuaFile("team_menu/loader.lua")
include("team_menu/loader.lua")


local Loader = TeamMenu.Loader


Loader.Debug(true)
Loader.RootFolder("team_menu")
Loader.PreloadModule(true)
Loader.ModuleAlias(true)
Loader.Load()