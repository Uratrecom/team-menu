TeamMenu.Loader = TeamMenu.Loader or {}


local Loader = TeamMenu.Loader
local self = Loader


self.debug = true
self.mainFolder = ""
self.priorityFiles = self.priorityFiles or {}


function Loader.Debug(enabled)
    self.debug = enabled
end


function Loader.MainFolder(folder)
    self.mainFolder = folder
end


function Loader.Priority(filename, priorityLevel)
    if self.priorityFiles[priorityLevel] == nil then
        self.priorityFiles[priorityLevel] = {}
    end

    self.priorityFiles[priorityLevel][filename] = true
end


function Loader.LoadFile(filename)
    local startTime = SysTime()


    if filename:find("/shared/") ~= nil then
        if self.debug then
            print(("[%s] Loading shared file: %s"):format(self.mainFolder, filename))
        end


        AddCSLuaFile(filename)
        include(filename)
    end


    if filename:find("/client/") ~= nil then
        if self.debug then
            print(("[%s] Loading client file: %s"):format(self.mainFolder, filename))
        end


        AddCSLuaFile(filename)


        if CLIENT then
            include(filename)
        end
    end


    if filename:find("/server/") ~= nil then
        if self.debug then
            print(("[%s] Loading server file: %s"):format(self.mainFolder, filename))
        end


        if SERVER then
            include(filename)
        end
    end


    if self.debug then
        print(("[%s] File has been successfully loaded in %0.3f seconds."):format(
            self.mainFolder, 
            SysTime() - startTime
        ))
    end
end


local function GetLuaFiles(path, tbl)
    local files = file.Find(path .. "/*.lua")
    local _, folders = file.Find(path .. "/*")


    for filename in pairs(files) do
        tbl[path .. "/" .. filename] = true
    end


    for folder in pairs(folders) do
        GetLuaFiles(path .. "/" .. folder, tbl)
    end


    return tbl
end


function Loader.Load()
    if self.debug then
        print(("[%s] Loading..."):format(self.mainFolder))
    end


    local memoryUsage = collectgarbage("count")
    local startTime = SysTime()
    local files = {}


    GetLuaFiles(self.mainFolder + "/shared", files)
    GetLuaFiles(self.mainFolder + "/client", files)
    GetLuaFiles(self.mainFolder + "/server", files)


    for priorityLevel, files in ipairs(self.priorityFiles) do
        for filename in pairs(files) do
            if filename:find("*") ~= nil then
                local path = filename:GetPathFromFilename()

                for _, f in ipairs(file.Find(filename, "LUA")) do
                    local filePath = path .. "/" .. f


                    self.LoadFile(filePath)


                    files[filePath] = nil
                end
            else
                self.LoadFile(self.mainFolder .. "/" .. filename)
            end

            files[filename] = nil
        end
    end
    

    for filename in pairs(files) do
        self.LoadFile(filename)
    end


    if self.debug then
        print(("[%s] Total time loading: %.3f seconds."):format(
            self.mainFolder,
            SysTime() - startTime
        ))

        print(("[%s] Total memory usage: %i KB."):format(
            self.mainFolder,
            collectgarbage("count") - memoryUsage
        ))
    end
end