TeamMenu.Utils = TeamMenu.Utils or {}


local Utils = TeamMenu.Utils


local isGlobalAvoidColon = false


function Utils.SetGlobalAvoidColon(avoid)
    isGlobalAvoidColon = tobool(avoid)
end


function Utils.SetGlobalTable(tbl)
	if not istable(tbl) then
		setmetatable(_G, nil)
		return
	end

    setmetatable(_G, {
		__index = function(self, key)
			if rawget(tbl, key) ~= nil then
				return rawget(tbl, key)
			end

			return rawget(self, key)
		end,
        
		__newindex = function(self, key, value)
			rawset(tbl, key, value)

            if isGlobalAvoidColon and isfunction(value) then
                Utils.AvoidColon(tbl, key)
            end
		end
	})
end


Utils.SetGlobalTable(Utils)


local isArgumentsEnabled = true
local argumentsTable = {}


function EnableArguments()
    isArgumentsEnabled = true
end


function DisableArguments()
    isArgumentsEnabled = false
end


function IsArgumentsEnabled()
    return isArgumentsEnabled
end


function GetArguments(func)
    local func = isfunction(func) and func or debug.getinfo(3, "f").func

    return argumentsTable[func]
end


function CheckArguments(...)
    local arguments = { ... }
    local functionName = debug.getinfo(2, "n").name
    local argumentsData = Utils.GetArguments()


    if not isArgumentsEnabled or argumentsData == nil then
        return true
    end


    for index=1, #argumentsData do
        local argument = arguments[index]
        local argumentData = argumentsData[index]


        if argumentData.required and argument == nil then
            local str = "Bad argument #%i '%s' to '%s' (argument is required)"
            

            str = str:format(index, argumentData.name, functionName)
            

            ErrorNoHaltWithStack(str)
            

            TeamMenu.AutoReport:Report(str)


            return false
        end


        if type(argumentData.type) == "string" and
           argumentData.type ~= "any" and
           not (not argumentData.required and argument == nil) and
           type(argument) ~= argumentData.type
        then
            local str = "Bad argument #%i '%s' to '%s' (%s expected, got %s)"
            

            str = str:format(
                index,
                argumentData.name,
                functionName,
                argumentData.type,
                type(argument)
            )


            ErrorNoHaltWithStack(str)


            TeamMenu.AutoReport:Report(str)

            
            return false
        end

        if type(argumentData.type) == "table" and
           not table.HasValue(argumentData.type, type(argument))
        then
            local str = "Bad argument #%i '%s' to '%s' (%s expected, got %s)"
            

            str = str:format(
                index,
                argumentData.name,
                functionName,
                table.concat(argumentData.type, " or "),
                type(argument)
            )
            

            ErrorNoHaltWithStack(str)


            TeamMenu.AutoReport:Report(str)

            
            return false
        end


        if type(argumentData.validator) == "function" then
            local success, message = argumentData.validator(argument, argumentData)

            if not success then
                local str = "Bad argument #%i '%s' to '%s'" .. (message and " (%s)" or "")


                str = str:format(
                    index, 
                    argumentData.name,
                    functionName, 
                    message
                )


                ErrorNoHaltWithStack(str)


                TeamMenu.AutoReport:Report(str)


                return false
            end
        end
    end


    return true
end


function Utils.AddArguments(func, argumentsData)
    if not Utils.CheckArguments(func, argumentsData) then
        return
    end

    argumentsTable[func] = argumentsData
end


Utils.AddArguments(Utils.AddArguments, {
    { name = "func", required = true, type = "function" },
    { name = "argumentsData", required = true, type = "table" }
})


function ColorValidator(argument, argumentData)
    if argument == nil and not argumentData.required then
        return true
    end


    if istable(argumentData.type) and 
       table.HasValue(argumentData.type, type(argument)) and
       not istable(argument)
    then
        return true
    end


    if not istable(argument) then
        return false, "table expected, got " .. type(argument)
    end
    

    if IsColor(argument) then
        return true
    end


    return false, "color expected, got " .. type(argument)
end


function TeamValidator(argument, argumentData)
    if argument == nil and not argumentData.required then
        return true
    end


    if istable(argumentData.type) and 
       table.HasValue(argumentData.type, type(argument)) and
       not istable(argument)
    then
        return true
    end


    if not istable(argument) then
        return false, "table expected, got " .. type(argument)
    end
    

    if Utils.IsTeam(argument) then
        return true
    end


    return false, "team expected, got " .. type(argument)
end


function LanguageValidator(argument, argumentData)
    if argument == nil and not argumentData.required then
        return true
    end
    

    if istable(argumentData.type) and 
       table.HasValue(argumentData.type, type(argument)) and
       not isstring(argument)
    then
        return true
    end
 

    if not isstring(argument) then
        return false, "string expected, got " .. type(argument)
    end
    

    if TeamMenu.Language.IsValid(argument) then
        return true
    end


    return false, "invalid language"
end


function MetaTableValidator(metaTable)
    if not Utils.CheckArguments(metaTable) then
        return
    end

    return function(argument, argumentData)
        if argument == nil and not argumentData.required then
            return true
        end


        if istable(argumentData.type) and 
           table.HasValue(argumentData.type, type(argument)) and
           not istable(argument)
        then
            return true
        end


        if not istable(argument) then
            return false, "table expected, got " .. type(argument)
        end


        if getmetatable(argument) ~= metaTable then
            return false, "wrong metatable"
        end


        return true
    end
end


Utils.AddArguments(Utils.MetaTableValidator, {
    { name = "metaTable", required = true, type = "table" }
})


function RangeValidator(min, max)
    if not Utils.CheckArguments(min, max) then
        return
    end

    return function(argument, argumentData)
        if argument == nil and not argumentData.required then
            return true
        end


        if istable(argumentData.type) and 
           table.HasValue(argumentData.type, type(argument)) and
           not isnumber(argument)
        then
            return true
        end


        if not isnumber(argument) then
            return false, "number expected, got " .. type(argument)
        end


        if argument < min or argument > max then
            return false, ("number must be in the range from %i to %i"):format(min, max)
        end
        

        return true
    end
end


Utils.AddArguments(Utils.RangeValidator, {
    { name = "min", required = true, type = "number" },
    { name = "max", required = true, type = "number" },
})


function Enum(tbl)
    if not Utils.CheckArguments(tbl) then
        return
    end


    for key, value in pairs(tbl) do
        tbl[key] = value
        tbl[value] = key
    end

    
    return setmetatable(tbl, {
        __len = function(self)
            return #Utils.table.GetNumberKeys(self)
        end,

        __tostring = function(self)
            return "Enum"
        end
    })
end


Utils.AddArguments(Utils.Enum, {
    { name = "tbl", required = true, type = "table" },
})


function AvoidColon(tbl, key)
	if not Utils.CheckArguments(tbl, key) then
        return
    end


    local func = tbl[key]


    if not isfunction(func) then
        return
    end


    tbl[key] = function(...)
        local self = ...

        if not istable(self) then
            self = tbl
        end

        return func(self, ...)
    end
end


Utils.AddArguments(Utils.AvoidColon, {
    { name = "tbl", required = true, type = "table" },
    { name = "key", required = true, type = "string" }
})


local teams = team.GetAllTeams()


function SaveTeams(filename)
    if not Utils.CheckArguments(filename) then
        return
    end

    file.Write(filename, util.TableToJSON(teams))
end


Utils.AddArguments(Utils.SaveTeams, {
    { name = "filename", required = true, type = "string" }
})


function LoadTeams(filename)
    if not Utils.CheckArguments(filename) then
        return
    end


    local json = file.Read(filename, "DATA")
    local tbl = util.JSONToTable(json)


    for teamIndex, teamTable in pairs(tbl) do
        if teams[teamIndex] then
            table.CopyFromTo(teamTable, teams[teamIndex])
        else
            teams[teamIndex] = teamTable
        end
    end
end


Utils.AddArguments(Utils.LoadTeams, {
    { name = "filename", required = true, type = "string" }
})


function ReferenceTable(tbl)
    if not Utils.CheckArguments(tbl) then
        return
    end
    
    return setmetatable({}, { __index = tbl })
end


Utils.AddArguments(Utils.ReferenceTable, {
    { name = "tbl", required = true, type = "table" },
})


Utils.SetGlobalTable(nil)


Utils.engine = Utils.ReferenceTable(engine)


Utils.SetGlobalTable(Utils.engine)


function GetMountedAddons()
    local addons = engine.GetAddons()
    local mountedAddons = {}


    for _, addon in ipairs(addons) do
        if addon.mounted then
            table.insert(mountedAddons, addon)
        end
    end


    return mountedAddons
end


Utils.SetGlobalTable(nil)


Utils.table = Utils.ReferenceTable(table)


Utils.SetGlobalTable(Utils.table)


local insert = table.insert


function GetNumberKeys(tbl)
    if not Utils.CheckArguments(tbl) then
        return
    end

    local keys = {}

    for index in pairs(tbl) do
        if isnumber(index) then
            insert(keys, index)
        end
    end

    return keys
end


Utils.AddArguments(Utils.table.GetNumberKeys, {
    { name = "tbl", required = true, type = "table" }
})


function MaxNumberKey(tbl)
    if not Utils.CheckArguments(tbl) then
        return
    end

	return math.max(unpack(Utils.table.GetNumberKeys(tbl)))
end


Utils.AddArguments(Utils.table.MaxNumberKey, {
    { name = "tbl", required = true, type = "table" }
})


function MinNumberKey(tbl)
    if not Utils.CheckArguments(tbl) then
        return
    end

	return math.min(unpack(Utils.table.GetNumberKeys(tbl)))
end


Utils.AddArguments(Utils.table.MinNumberKey, {
    { name = "tbl", required = true, type = "table" }
})


Utils.SetGlobalTable(nil)


Utils.hook = Utils.ReferenceTable(hook)


Utils.SetGlobalTable(Utils.hook)


local hooksTable = hook.GetTable()


function Get(eventName, hookId)
    if not Utils.CheckArguments(eventName, hookId) then
        return
    end

    if not hook.Exists(eventName, hookId) then
        return
    end

    return hooksTable[eventName][hookId]
end


Utils.AddArguments(Utils.hook.Get, {
    { name = "eventName", required = true, type = "string" },
    { name = "hookId", required = true, type = "string" }
})


function Exists(eventName, hookId)
    if not Utils.CheckArguments(eventName, hookId) then
        return
    end

    local eventHooks = hooksTable[eventName]
    
    return (eventHooks and eventHooks[hookId]) and true or false
end


Utils.AddArguments(Utils.hook.Exists, {
    { name = "eventName", required = true, type = "string" },
    { name = "hookId", required = true, type = "string" }
})


function SimpleAdd(eventName, func)
    if not Utils.CheckArguments(eventName, func) then
        return
    end

    hook.Add(
        eventName,
        ("%.8x_%.2x_%x.4"):format(
            SysTime(),
            math.random(0, 0xff),
            math.random(0, 0xffff)
        ),
        func
    )
end


Utils.AddArguments(Utils.hook.Exists, {
    { name = "eventName", required = true, type = "string" },
    { name = "func", required = true, type = "function" }
})


function MultipleAdd(hooks)
    if not Utils.CheckArguments(hooks) then
        return
    end

    local hookFunc = nil

    for _, hookData in ipairs(hooks) do
        if isfunction(hookData) then
            hookFunc = hookData
        else    
            hook.Add(hookData.event, hookData.id, hookFunc)
        end
    end
end

Utils.AddArguments(Utils.hook.MultipleAdd, {
    {
        name = "hooks",
        required = true,
        type = "table",
        validator = function(argument)
            for _, hookData in pairs(argument) do
                if not isfunction(hookData) and not istable(hookData) then
                    return false, "function or table expected, got " .. type(hookData)
                end

                if istable(hookData) then
                    local hookEvent = hookData.event
                    local hookId = hookData.id
            
                    if not isstring(hookEvent) then
                        return false, "string expected for 'hookData.event', got " .. type(hookEvent)
                    end

                    if not isstring(hookId) then
                        return false, "string expected for 'hookData.id', got " .. type(hookId)
                    end
                end
            end

            return true
        end
    }
})


Utils.SetGlobalTable(nil)


local COLOR = FindMetaTable("Color")


function COLOR:GetAverage()
    return (self.r+self.g+self.b)/3
end


function COLOR:GetBrightness()
    return self:GetAverage()/255
end


local PLAYER = FindMetaTable("Player")


function PLAYER:GetTeam()
    return TeamMenu.Team(self:Team())
end


Utils.SetGlobalTable(Utils)


function IsTeam(value)
    return istable(value) and getmetatable(value) == TeamMenu.TEAM
end


function IsPlayer(value)
    return type(value) == "Player"
end


function SetGlobalVarArray(index, array)
    if not Utils.CheckArguments(index, array) then
        return
    end

    SetGlobalInt(index .. ".length", #array)

    for k, v in ipairs(array) do
        SetGlobalVar(index .. "." .. tostring(k), v)
    end
end


Utils.AddArguments(Utils.SetGlobalVarArray, {
    { name = "index", required = true, type = "string" },
    { name = "array", required = true, type = "table" }
})


function GetGlobalVarArray(index)
    if not Utils.CheckArguments(index) then
        return
    end

    local tbl = {}

    for i=1, GetGlobalInt(index .. ".length") do
        table.insert(tbl, GetGlobalVar(i .. "." .. tostring(i)))
    end

    return tbl
end


Utils.AddArguments(Utils.GetGlobalVarArray, {
    {
        name = "index",
        required = true,
        type = "string",
        validator = function(argument, argumentData)
            if GetGlobalInt(argument .. ".length", -1) == -1 then
                return false, "index '" .. argument .. ".length' does not exist"
            end

            return true
        end
    }
})


Utils.SetGlobalTable(nil)


Utils.math = Utils.ReferenceTable(math)


Utils.SetGlobalTable(Utils.math)


function Center(x, y, width, height, width2, height2)
    if not Utils.CheckArguments(x, y, width, height, width2, height2) then
        return
    end

    return width / 2 - width2 / 2 + x, height / 2 - height2 / 2 + y, width2, height2
end


Utils.AddArguments(Utils.math.Center, {
    { name = "x", required = true, type = "number" },
    { name = "y", required = true, type = "number" },
    { name = "width", required = true, type = "number" },
    { name = "height", required = true, type = "number" },
    { name = "width2", required = true, type = "number" },
    { name = "height2", required = true, type = "number" }
})


local Round = math.Round
local concat = table.concat
local QuadraticCurve_cache = {}


function QuadraticCurve(t, x, y, x2, y2, x3, y3)
    if not Utils.CheckArguments(t, x, y, x2, y2, x3, y3) then
        return
    end


    x = Round(x)
    y = Round(y)
    x2 = Round(x2)
    y2 = Round(y2)
    x3 = Round(x3)
    y3 = Round(y3)


    local cacheKey = concat({ t, x, y, x2, y2, x3, y3 }, " ")
    local cacheValue = QuadraticCurve_cache[cacheKey]


    if cacheValue then
        return cacheValue.x, cacheValue.y
    end


    local value = (1 - t) ^ 2


    x = x * value
    y = y * value


    value = 2 * (1 - t) * t


    x2 = x2 * value
    y2 = y2 * value


    value = t ^ 2
    

    x3 = x3 * value
    y3 = y3 * value


    x = x + x2 + x3
    y = y + y2 + y3


    QuadraticCurve_cache[cacheKey] = { x = x, y = y }
    
    
    return x, y
end


Utils.AddArguments(Utils.math.QuadraticCurve, {
    { name = "t", required = true, type = "number" },
    { name = "x", required = true, type = "number" },
    { name = "y", required = true, type = "number" },
    { name = "x2", required = true, type = "number" },
    { name = "y2", required = true, type = "number" },
    { name = "x3", required = true, type = "number" },
    { name = "y3", required = true, type = "number" }
})


local concat = table.concat
local insert = table.insert
local FullQuadraticCurve_cache = {}


function FullQuadraticCurve(verticesCount, x, y, x2, y2, x3, y3)
    if not Utils.CheckArguments(verticesCount, x, y, x2, y2, x3, y3) then
        return
    end


    local cacheKey = concat({ verticesCount, x, y, x2, y2, x3, y3 }, " ")
    local cacheValue = FullQuadraticCurve_cache[cacheKey]


    if cacheValue then
        return cacheValue
    end


    local verticesTable = {}


    for t=0, 1, 1/verticesCount do
        local x, y = Utils.math.QuadraticCurve(t, x, y, x2, y2, x3, y3)

        insert(verticesTable, { x = x, y = y })
    end


    FullQuadraticCurve_cache[cacheKey] = verticesTable


    return verticesTable
end


Utils.AddArguments(Utils.math.FullQuadraticCurve, {
    { name = "verticesCount", required = true, type = "number" },
    { name = "x", required = true, type = "number" },
    { name = "y", required = true, type = "number" },
    { name = "x2", required = true, type = "number" },
    { name = "y2", required = true, type = "number" },
    { name = "x3", required = true, type = "number" },
    { name = "y3", required = true, type = "number" }
})


if not CLIENT then
    return
end


Utils.SetGlobalTable(nil)


Utils.surface = Utils.ReferenceTable(surface)


Utils.SetGlobalTable(Utils.surface)


TeamMenu.LINE_MODE = Utils.Enum {
    "INNER",
    "OUTER",
    "BOTH"
}


local LINE_MODE = TeamMenu.LINE_MODE
local pi = math.pi
local atan2 = math.atan2
local sin = math.sin
local cos = math.cos
local insert = table.insert


function DrawLine(thickness, mode, x, y, x2, y2)
    if not Utils.CheckArguments(thickness, mode, x, y, x2, y2) then
        return
    end


    local pi = pi / 2
    local angle = atan2(y2 - y, x2 - x)
    local verticesTable = {}


    if mode == LINE_MODE.INNER then
        thickness = thickness * 2

        insert(verticesTable, { 
            x = x + thickness * cos(angle + pi),
            y = y + thickness * sin(angle + pi) 
        })

        insert(verticesTable, { 
            x = x + 0 * cos(angle - pi),
            y = y + 0 * sin(angle - pi) 
        })

        insert(verticesTable, { 
            x = x2 + 0 * cos(angle - pi),
            y = y2 + 0 * sin(angle - pi) 
        })

        insert(verticesTable, { 
            x = x2 + thickness * cos(angle + pi),
            y = y2 + thickness * sin(angle + pi) 
        })
    end


    if mode == LINE_MODE.OUTER then
        thickness = thickness * 2
        
        insert(verticesTable, { 
            x = x + 0 * cos(angle + pi),
            y = y + 0 * sin(angle + pi) 
        })

        insert(verticesTable, { 
            x = x + thickness * cos(angle - pi),
            y = y + thickness * sin(angle - pi) 
        })

        insert(verticesTable, { 
            x = x2 + thickness * cos(angle - pi),
            y = y2 + thickness * sin(angle - pi) 
        })

        insert(verticesTable, { 
            x = x2 + 0 * cos(angle + pi),
            y = y2 + 0 * sin(angle + pi) 
        })
    end


    if mode == LINE_MODE.BOTH then
        insert(verticesTable, { 
            x = x + thickness * cos(angle + pi),
            y = y + thickness * sin(angle + pi) 
        })

        insert(verticesTable, { 
            x = x + thickness * cos(angle - pi),
            y = y + thickness * sin(angle - pi) 
        })

        insert(verticesTable, { 
            x = x2 + thickness * cos(angle - pi),
            y = y2 + thickness * sin(angle - pi) 
        })

        insert(verticesTable, { 
            x = x2 + thickness * cos(angle + pi),
            y = y2 + thickness * sin(angle + pi) 
        })
    end


    surface.DrawPoly(verticesTable)


    return verticesTable
end


Utils.AddArguments(Utils.surface.DrawLine, {
    { name = "thickness", required = true, type = "number" },
    { name = "mode", required = true, type = "number" },
    { name = "x", required = true, type = "number" },
    { name = "y", required = true, type = "number" },
    { name = "x2", required = true, type = "number" },
    { name = "y2", required = true, type = "number" }
})


function DrawOutlinedPolygon(thickness, mode, verticesTable)
    if not Utils.CheckArguments(thickness, mode, verticesTable) then
        return
    end
    

    local previousPoint = verticesTable[#verticesTable]


    for _, point in ipairs(verticesTable) do
        Utils.surface.DrawLine(
            thickness,
            mode,
            previousPoint.x,
            previousPoint.y,
            point.x,
            point.y
        )

        previousPoint = point
    end
end


Utils.AddArguments(Utils.surface.DrawOutlinedPolygon, {
    { name = "thickness", required = true, type = "number" },
    { name = "mode", required = true, type = "number" },
    { name = "verticesTable", required = true, type = "table" }
})


function DrawQuadraticCurve(verticesCount, thickness, mode, x, y, x2, y2, x3, y3)
    if not Utils.CheckArguments(verticesCount, thickness, mode, x, y, x2, y2, x3, y3) then
        return
    end
    

    local verticesTable = Utils.math.FullQuadraticCurve(verticesCount, x, y, x2, y2, x3, y3)
    local previousPoint = verticesTable[1]


    for _, point in ipairs(verticesTable) do
        Utils.surface.DrawLine(
            thickness,
            mode,
            previousPoint.x,
            previousPoint.y,
            point.x,
            point.y
        )

        previousPoint = point
    end
end


Utils.AddArguments(Utils.surface.DrawOutlinedPolygon, {
    { name = "verticesCount", required = true, type = "number" },
    { name = "thickness", required = true, type = "number" },
    { name = "mode", required = true, type = "number" },
    { name = "x", required = true, type = "number" },
    { name = "y", required = true, type = "number" },
    { name = "x2", required = true, type = "number" },
    { name = "y2", required = true, type = "number" },
    { name = "x3", required = true, type = "number" },
    { name = "y3", required = true, type = "number" }
})


Utils.SetGlobalTable(nil)


Utils.draw = Utils.ReferenceTable(draw)


Utils.SetGlobalTable(Utils.draw)


function RoundedRectangle(t, verticesCount, lineThickness, lineMode, x, y, width, height)    
    Utils.surface.DrawQuadraticCurve(
        verticesCount,
        lineThickness,
        lineMode,
        x,
        Clamp(Lerp(t, y, y + height), x, y + height / 2),
        x,
        y,
        Clamp(Lerp(t, x, x + width), x, x + width / 2),
        y
    )

    Utils.surface.DrawLine(
        lineThickness,
        lineMode,
        Clamp(Lerp(t, x, x + width), x, x + width / 2),
        y,
        Clamp(Lerp(1 - t, x, x + width), x + width / 2, x + width),
        y
    )

    Utils.surface.DrawQuadraticCurve(
        verticesCount,
        lineThickness,
        lineMode,
        Clamp(Lerp(1 - t, x, x + width), x + width / 2, x + width),
        y,
        x + width,
        y,
        x + width,
        Clamp(Lerp(t, y, y + height), y, y + height / 2)
    )

    Utils.surface.DrawLine(
        lineThickness,
        lineMode,
        x + width,
        Clamp(Lerp(t, y, y + height), y, y + height / 2),
        x + width,
        Clamp(Lerp(1 - t, y, y + height), y + height / 2, y + height)
    )

    Utils.surface.DrawQuadraticCurve(
        verticesCount,
        lineThickness,
        lineMode,
        x + width,
        Clamp(Lerp(1 - t, y, y + height), y + height / 2, y + height),
        x + width,
        y + height,
        Clamp(Lerp(1 - t, x, x + width), x + width / 2, x + width),
        y + height
    )

    Utils.surface.DrawLine(
        lineThickness,
        lineMode,
        Clamp(Lerp(1 - t, x, x + width), x + width / 2, x + width),
        y + height,
        Clamp(Lerp(t, x, x + width), x, x + width / 2),
        y + height
    )

    Utils.surface.DrawQuadraticCurve(
        verticesCount,
        lineThickness,
        lineMode,
        Clamp(Lerp(t, x, x + width), x, x + width / 2),
        y + height,
        x,
        y + height,
        x,
        Clamp(Lerp(1 - t, y, y + height), y + height / 2, y + height)
    )

    Utils.surface.DrawLine(
        lineThickness,
        lineMode,
        x,
        Clamp(Lerp(1 - t, y, y + height), y + height / 2, y + height),
        x,
        Clamp(Lerp(t, y, y + height), y, y + height / 2)
    )

    surface.SetDrawColor(Color(0, 0, 0, 100))
    surface.DrawRect(x, y, width, height)
end


function SimpleRoundedRectangle(t, lineThickness, x, y, width, height)    
    Utils.draw.RoundedRectable(
        t,
        32,
        lineThickness,
        LINE_MODE.INNER,
        x,
        y,
        width,
        height
    )
end


Utils.SetGlobalTable(nil)