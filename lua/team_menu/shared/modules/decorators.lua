Module("TeamMenu.Decorators")


local Decorator = Require("TeamMenu.Decorator")
local ConVars = nil


PostRequire(function()
    ConVars = Require("TeamMenu.ConVars")
end)


function LinkedTable(tbl)
    return setmetatable({
        __tbl = tbl,
        __type = "linkedtable",

        ChangeTable = function(self, tbl)
            rawset(self, "__tbl", tbl)
        end
    }, 
    {
        __index = function(self, key)
            return rawget(self, key) and rawget(self, key) or self.__tbl[key]
        end,

        __newindex = function(self, key, value)
            self.__tbl[key] = value
        end,

        __tostring = function()
            return ("linkedtable<%s>"):format(tostring(self.__tbl))
        end,
    })
end


local ipairs = _G.ipairs
local type = _G.type
local table = _G.table
local ErrorNoHaltWithStack = _G.ErrorNoHaltWithStack


local registeredTypes = {}


local function RegisterType(name, validator)
    registeredTypes[name] = validator
end


local function CheckType(types, value)
    local valueType = type(value)

    for _, t in pairs(types) do
        local typeValidator = registeredTypes[t]

        if typeValidator ~= nil then
            local success, reason = typeValidator(value)

            if not success then
                reason = reason or ("%s expected, got %s"):format(t, valueType)

                return false, "(" .. reason .. ")"
            end
        else
            if valueType ~= t then
                return false, ("%s expected, got %s"):format(t, valueType)
            end
        end
    end

    return true
end


local function CheckTable(items, tbl, errorMessage)
    for index, item in ipairs(items) do
        local value = tbl[index]
        local types = item:gsub("%s", ""):Split("|")


        local success, reason = CheckType(types, value)


        if not success then
            errorMessage = errorMessage:format(
                index,
                reason
            )


            ErrorNoHaltWithStack(errorMessage)


            return true
        end
    end
end


Arguments = Decorator.Create({
    RegisterType = RegisterType,

    Call = function(arguments, functionArguments)
        if not ConVars.GetBool("debug") then
            return
        end

        return CheckTable(arguments, functionArguments, "Bad argument #i (%s)")
    end
})


Return = Decorator.Create({
    RegisterType = RegisterType,

    Result = function(arguments, result)
        if not ConVars.GetBool("debug") then
            return
        end

        CheckTable(arguments, result, "Bad return value #i (%s)")
    end
})


ServerSide = Decorator.Create({
    Call = function()
        return not SERVER
    end
})


ClientSide = Decorator.Create({
    Call = function()
        return not CLIENT
    end
})


local startTime = nil


Time = Decorator.Create({
    Call = function(arguments)
        startTime = SysTime()
    end,

    Result = function(arguments)
        local name = arguments[1]

        print(("[%s] execution time: %0.3f seconds."):format(
            name or "Unnamed",
            SysTime() - startTime
        ))
    end
})


PostRequire(function() 
    function test(a, b, c) return (a or 1) + (b or 1) * (c or 1) end
    
    print(test)
    
    test = Arguments("number|nil", "number|nil", "number|nil") .. test

    print(test)
    
    test = Return("number|nil") .. test
    
    test()
end)