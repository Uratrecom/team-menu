TeamMenu.Loader = TeamMenu.Loader or {}


local Loader = TeamMenu.Loader
local self = Loader


local function SetTableValue(tbl, path, value)
    local keys = path:Split(".")

    for index, key in ipairs(keys) do
        if index == #keys then
            tbl[key] = value

            return value
        end


        if tbl[key] == nil then
            tbl[key] = {}
        end


        tbl = tbl[key]
    end
end


local function GetTableValue(tbl, path)
    local keys = path:Split(".")


    for index, key in ipairs(keys) do
        tbl = tbl[key]


        if tbl == nil then
            return
        end


        if index == #keys then
            return tbl
        end
    end
end


local function SafeGetTable(tbl, path)
    local value = GetTableValue(tbl, path)


    if value == nil then
        return SetTableValue(tbl, path, {})
    end


    return value
end


local function FolderExists(folderPath, gamePath)
    local _, folders = file.Find(folderPath .. "*", gamePath)

    return folders and
           #folders ~= 0 and
           table.HasValue(folders, folderPath:GetFileFromFilename())
end


self.debug = false
self.rootFolder = ""
self.priorityFiles = {}
self.preloadModule = false
self.moduleAlias = true
self.files = {}
self.moduleMeta = {}


local moduleAliases = SafeGetTable(_G, "Uratrecom.moduleAliases")


function Loader.Debug(enabled)
    self.debug = enabled
end


function Loader.RootFolder(rootFolder)
    self.rootFolder = rootFolder
end


function Loader.Priority(path, level)
    SafeGetTable(self.priorityFiles, tostring(level))[path] = true
end


function Loader.PreloadModule(enabled)
    self.preloadModule = enabled
end


function Loader.ModuleAlias(enabled)
    self.moduleAlias = enabled
end


function Loader.LoadFile(filename)
    local startTime = SysTime()


    if filename:find("/shared/") ~= nil then
        if self.debug then
            print(("[%s] Loading shared file: %s"):format(self.rootFolder, filename))
        end


        AddCSLuaFile(filename)
        include(filename)
    end


    if filename:find("/client/") ~= nil then
        if self.debug then
            print(("[%s] Loading client file: %s"):format(self.rootFolder, filename))
        end


        AddCSLuaFile(filename)


        if CLIENT then
            include(filename)
        end
    end


    if filename:find("/server/") ~= nil then
        if self.debug then
            print(("[%s] Loading server file: %s"):format(self.rootFolder, filename))
        end


        if SERVER then
            include(filename)
        end
    end


    if self.debug then
        print(("[%s] File has been successfully loaded in %0.3f seconds."):format(
            self.rootFolder, 
            SysTime() - startTime
        ))
    end
end


function Loader.GetFiles(path)
    if path:find("*") == nil then
        return { path }
    end


    local base = path:GetPathFromFilename()
    local tbl = {}


    for _, filename in ipairs(file.Find(path, "LUA")) do
        table.insert(tbl, base .. "/" .. filename)
    end


    return tbl
end


function Loader.GetLuaFiles(path, tbl)
    tbl = tbl or {}


    local files = file.Find(path .. "/*.lua", "LUA")
    local _, folders = file.Find(path .. "/*", "LUA")


    for _, filename in pairs(files) do
        tbl[path .. "/" .. filename] = true
    end


    for _, folder in pairs(folders) do
        if folder ~= "modules" then
            self.GetLuaFiles(path .. "/" .. folder, tbl)
        end
    end


    return tbl
end


function Loader.Setup()
    table.Empty(self.files)

    self.GetLuaFiles(self.rootFolder .. "/shared", self.files)
    self.GetLuaFiles(self.rootFolder .. "/client", self.files)
    self.GetLuaFiles(self.rootFolder .. "/server", self.files)
end


function Loader.GetModules()
    local sharedPath = self.rootFolder .. "/shared/modules"
    local clientPath = self.rootFolder .. "/client/modules"
    local serverPath = self.rootFolder .. "/server/modules"


    local tbl = {}


    if FolderExists(sharedPath, "LUA") then
        self.GetLuaFiles(sharedPath, SafeGetTable(tbl, "shared"))
    end


    if FolderExists(clientPath, "LUA") then
        self.GetLuaFiles(clientPath, SafeGetTable(tbl, "client"))
    end


    if FolderExists(serverPath, "LUA") then
        self.GetLuaFiles(serverPath, SafeGetTable(tbl, "server"))
    end


    return tbl
end


function Loader.GetModuleAlias(moduleFile)
    local fp = file.Open(moduleFile, "r", "LUA")


    if fp == nil then
        ErrorNoHaltWithStack("File doesn't exist: " .. modulePath)

        return
    end


    local code = fp:Read()


    fp:Close()


    local moduleAlias = code:match("Module%(([^%)]+)%)")


    return moduleAlias and moduleAlias:gsub("[\"']", "") or nil
end


function Loader.LoadModule(modulePath)
    if self.debug then
        print(("[%s] Loading module: %s"):format(self.rootFolder, modulePath))
    end


    if self.preloadModule then
        self.Require(modulePath)
    end
end


function Loader.LoadModuleAliases()
    if not self.moduleAlias then
        return 
    end


    local modules = self.GetModules()
    local moduleFiles = {}


    table.Merge(moduleFiles, SafeGetTable(modules, "shared"))
    table.Merge(moduleFiles, SafeGetTable(modules, "client"))
    table.Merge(moduleFiles, SafeGetTable(modules, "server"))


    for moduleFile in pairs(moduleFiles) do
        local alias = self.GetModuleAlias(moduleFile)

        if alias and moduleAliases[alias] == nil then
            moduleAliases[alias] = moduleFile
        end
    end
end


function Loader.LoadModules()
    local startTime = SysTime()


    if self.debug then
        print(("[%s] Loading modules..."):format(self.rootFolder))
    end


    local modules = self.GetModules()


    if modules.shared and not table.IsEmpty(modules.shared) then
        for moduleFile in pairs(modules.shared) do
            self.LoadModule(moduleFile)
            AddCSLuaFile(moduleFile)
        end
    end


    if modules.client and not table.IsEmpty(modules.client) then
        for moduleFile in pairs(modules.client) do
            if CLIENT then
                self.LoadModule(moduleFile)
            end

            AddCSLuaFile(moduleFile)
        end
    end


    if modules.server and not table.IsEmpty(modules.server) and SERVER then
        for moduleFile in pairs(modules.server) do
            self.LoadModule(moduleFile)
        end
    end


    if self.debug then
        print(("[%s] Modules time loading: %.3f seconds."):format(
            self.rootFolder,
            SysTime() - startTime
        ))
    end
end


function Loader.LoadPriorityFiles()
    for level, files in ipairs(self.priorityFiles) do
        for filename in pairs(files) do
            local files = self.GetFiles(filename)


            for _, f in ipairs(files) do
                local path = self.rootFolder .. "/" .. f

                self.LoadFile(path)
                self.files[path] = nil
            end


            self.files[filename] = nil
        end
    end
end


function Loader.LoadFiles()
    for filename in pairs(self.filesToLoad) do
        self.LoadFile(filename)
        self.filesToLoad[filename] = nil
    end
end


function Loader.Load()
    if self.debug then
        print(("[%s] Loading..."):format(self.rootFolder))
    end


    local memoryUsage = collectgarbage("count")
    local startTime = SysTime()


    -- self.Setup()
    self.LoadModuleAliases()
    self.LoadModules()
    -- self.LoadPriorityFiles()
    -- self.LoadFiles()


    if self.debug then
        print(("[%s] Total time loading: %.3f seconds."):format(
            self.rootFolder,
            SysTime() - startTime
        ))

        print(("[%s] Total memory usage: %.3f KB."):format(
            self.rootFolder,
            collectgarbage("count") - memoryUsage
        ))
    end
end


local moduleMeta = self.moduleMeta


moduleMeta.__index = moduleMeta


-- Globals for modules
moduleMeta._G = _G
moduleMeta.print = print
moduleMeta.SERVER = SERVER
moduleMeta.CLIENT = CLIENT


function moduleMeta.__call(self, ...)
    local __call = rawget(self, "__call")
    
    if isfunction(__call) then
        return __call(...)
    end
end


function moduleMeta.SetGlobal(key, value)
    _G[key] = value
end


function moduleMeta.GetGlobal(...)
    local keys = { ... }


    if #keys == 1 then
        return _G[keys[1]]
    end


    local values = {}


    for _, key in ipairs(keys) do
        table.insert(values, _G[key])
    end


    return unpack(values)
end


local loaders = {
    -- Trying to load local module
    -- Example: shared.utils
    function(moduleName)
        local realm = nil


        if moduleName:StartWith("shared") or
           moduleName:StartWith("client") or
           moduleName:StartWith("server")
        then
            realm = moduleName:Left(6)
            moduleName = moduleName:sub(8)
        end


        moduleName = moduleName:gsub(".", "/")


        if realm == nil then
            realm = SERVER and "server" or "client"
        end
    
    
        local modulePath = self.rootFolder .. "/" .. realm .. "/modules/" .. moduleName .. ".lua"
        

        if file.Exists(modulePath, "LUA") then
            return modulePath
        end
    end,


    -- Trying to load global module
    -- Example: team_menu.shared.utils
    function(moduleName)
        moduleName = moduleName:gsub(".", "/") .. ".lua"
        moduleName = moduleName:gsub("shared", "shared/modules")
        moduleName = moduleName:gsub("client", "client/modules")
        moduleName = moduleName:gsub("server", "server/modules")

        if file.Exists(moduleName, "LUA") then
            return moduleName
        end
    end,


    -- Trying to load module by alias
    -- Example: TeamMenu.Utils
    function(moduleName)
        local modulePath = moduleAliases[moduleName]

        if modulePath then
            return modulePath
        end
    end,


    -- Trying to load module by absolute path
    -- Example: team_menu/shared/modules/utils.lua
    function(moduleName)
        if file.Exists(moduleName, "LUA") then
            return moduleName
        end
    end
}


local function TryLoad(moduleName)
    for _, loader in ipairs(loaders) do
        modulePath = loader(moduleName)

        if modulePath ~= nil then
            return modulePath
        end
    end

    return false
end


function moduleMeta.Module(moduleAlias)
    local moduleTable = getfenv(2)
    local globalModule = GetTableValue(_G, moduleAlias)


    if globalModule == nil then
        SetTableValue(_G, moduleAlias, moduleTable)
    else
        table.Merge(globalModule, moduleTable)
        moduleTable = globalModule
    end


    setmetatable(moduleTable, moduleMeta)


    moduleTable._M = moduleTable._M or moduleTable
    moduleTable._MODULE = moduleTable._M
    moduleTable._NAME = moduleTable._NAME or moduleAlias
    moduleTable._PATH = moduleTable._PATH or debug.getinfo(2).short_src


    setfenv(2, moduleTable)


    return moduleTable
end


function moduleMeta.ModuleExists(moduleName)
    return TryLoad(moduleName) ~= false
end


function moduleMeta.Require(moduleName, ...)
    local moduleFile = TryLoad(moduleName)


    if not moduleFile then
        ErrorNoHaltWithStack("No module with name '" .. moduleName .. "'")

        return
    end


    local cachedResult = package.loaded[moduleFile]


    if cachedResult ~= nil then
        return cachedResult
    end


    local mod = CompileFile(moduleFile)


    setfenv(mod, setmetatable({}, moduleMeta))


    local result = mod(...)
    local moduleTable = getfenv(mod)


	if result == nil and moduleTable._NAME ~= nil then
		result = moduleTable
	end


	package.loaded[moduleFile] = result ~= nil and result or true


    return result
end


Loader.Require = moduleMeta.Require