Uratrecom = Uratrecom or {}


TeamMenu = TeamMenu or {}


Uratrecom.TeamMenu = TeamMenu


local highPriority = {
    "team_menu/shared/convars.lua",
    "team_menu/shared/utils.lua",
    "team_menu/shared/autoreport.lua",
    "team_menu/client/language.lua"
}


print("[TeamMenu] Loading...")


local startTime = SysTime()


for _, filename in ipairs(highPriority) do
    if filename:find("shared/") ~= nil then
        AddCSLuaFile(filename)
        include(filename)
    end

    
    if filename:find("client/") ~= nil then
        AddCSLuaFile(filename)
    
        if CLIENT then
            include(filename)
        end
    end


    if filename:find("server/") ~= nil then
        if SERVER then
            include(filename)
        end
    end
end


for _, filename in pairs(file.Find("team_menu/shared/*", "LUA")) do
    local path = "team_menu/shared/" .. filename

    if not table.HasValue(highPriority, path) then
        AddCSLuaFile(path)
        include(path)
    end
end


for _, filename in pairs(file.Find("team_menu/client/*", "LUA")) do
    local path = "team_menu/client/" .. filename
    
    if not table.HasValue(highPriority, path) then
        AddCSLuaFile(path)
        
        if CLIENT then
            include(path)
        end
    end
end


if SERVER then
    for _, filename in pairs(file.Find("team_menu/server/*", "LUA")) do
        if not table.HasValue(highPriority, filename) then
            include("team_menu/server/" .. filename)
        end
    end
end


local endTime = SysTime() - startTime


print(("[TeamMenu] Loaded in %.3f seconds"):format(endTime))


TeamMenu.Utils.SetGlobalTable(nil)
TeamMenu.Utils.SetGlobalAvoidColon(false)