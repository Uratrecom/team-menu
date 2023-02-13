local Utils = TeamMenu.Utils


-- FIX


Utils.Arguments = Utils.Arguments or {}


local self = Utils.Arguments


Utils.SetGlobalTable(Utils.Arguments)


tbl = {}
enabled = true
types = {}


function IsEnabled()
    return self.GetEnabled()
end


function GetFunctionArguments(func)
    func = isfunction(func) and func or debug.getinfo(3, "f").func

    return Arguments.argumentsTable[func]
end


function ArgumentIsRequiredError(index, argumentData, functionName)
    local str = "Bad argument #%i '%s' to '%s' (argument is required)"
            

    str = str:format(index, argumentData.name, functionName)
    

    ErrorNoHaltWithStack(str)
end


local concat = table.concat


function WrongTypeError(index, argumentData, functionName, typeName)
    local str = "Bad argument #%i '%s' to '%s' (%s expected, got %s)"


    local type = argumentData.type


    str = str:format(
        index,
        argumentData.name,
        functionName,
        istable(type) and concat(type, " or ") or type,
        typeName
    )


    ErrorNoHaltWithStack(str)
end


function ValidationError(index, argumentData, functionName, errorMessage)
    local str = "Bad argument #%i '%s' to '%s'" .. (errorMessage and " (%s)" or "")


    str = str:format(
        index, 
        argumentData.name,
        functionName,
        errorMessage
    )


    ErrorNoHaltWithStack(str)
end


local t = type


function CheckType(type, index, argument, argumentData, functionName)
    if Arguments.TypeExists(type) then
        local validator = self.GetValidator(type)


        local success, errorMessage = validator(argument, argumentData)


        if not success then
            self.ValidationError(
                index,
                argumentData,
                functionName,
                errorMessage
            )

            return false
        end


        return
    end

    if t(argument) ~= type then
        Arguments.WrongTypeError(
            index,
            argumentData,
            functionName,
            self.DetectType(argument)
        )
        
        return false
    end
end


function Check(...)
    local arguments = { ... }
    local functionName = debug.getinfo(2, "n").name
    local argumentsData = self.GetFunctionArguments()


    if not self.IsEnabled() or argumentsData == nil then
        return true
    end


    for index=1, #argumentsData do
        local argument = arguments[index]
        local argumentData = argumentsData[index]


        local required = argumentData.required
        local type = argumentData.type
        local validator = argumentData.validator


        if required and argument == nil then
            Arguments.ArgumentIsRequiredError(
                index,
                argumentData,
                functionName
            )

            return false
        end


        if t(type) == "string" and
           required and argument ~= nil and
           not Arguments.CheckType(type, index, argument, argumentData, functionName)
        then
            return false
        end


        if t(type) == "table" then
            for _, argumentType in pairs(type) do
                local success = Arguments.CheckType(
                    argumentType,
                    index,
                    argument,
                    argumentData,
                    functionName
                )

                if not success then
                    return false
                end
            end
        end


        if t(argumentData.validator) == "function" then
            local success, errorMessage = argumentData.validator(argument, argumentData)

            if not success then
                Arguments.ValidationError(
                    index,
                    argumentData,
                    functionName,
                    errorMessage
                )

                return false
            end
        end
    end


    return true
end


Utils.CheckArguments = Check


function Add(func, argumentsData)
    if not Utils.CheckArguments(func, argumentsData) then
        return
    end

    self.tbl[func] = argumentsData
end


Utils.AddArguments = Add


Utils.AddArguments(Add, {
    { name = "func", required = true, type = "function" },
    { name = "argumentsData", required = true, type = "table" }
})


function GetTypes()
    return self.types
end


function RegisterType(typeName, typeValidator)
    if not Utils.CheckArguments(typeName, typeValidator) then
        return
    end

    self.types[typeName] = typeValidator
end


Utils.AddArguments(RegisterType, {
    { name = "typeName", required = true, type = "string" },
    { name = "typeValidator", required = true, type = "function" }
})


function GetType(typeName)
    if not Utils.CheckArguments(typeName) then
        return
    end

    return self.types[typeName]
end


Utils.AddArguments(GetType, {
    { name = "typeName", required = true, type = "string" }
})


function TypeExists(typeName)
    if not Utils.CheckArguments(typeName) then
        return
    end

    return Arguments.GetType(typeName) ~= nil
end


Utils.AddArguments(TypeExists, {
    { name = "typeName", required = true, type = "string" }
})


function DetectType(value)
    local types = self.GetTypes()


    local tbl = {}


    if types.color(value, tbl) then
        return "color"
    end


    if types.player(value, tbl) then
        return "player"
    end


    if types.entity(value, tbl) then
        return "entity"
    end


    if types.team(value, tbl) then
        return "team"
    end


    if types.prop(value, tbl) then
        return "prop"
    end


    if types.vehicle(value, tbl) then
        return "vehicle"
    end


    return type(value)
end


-- Default types


RegisterType("any", function(argument, argumentsData)
    return true
end)


RegisterType("color", function(argument, argumentsData)
    if argument == nil and not argumentData.required then
        return true
    end


    if istable(argumentData.type) and 
       table.HasValue(argumentData.type, Arguments.DetectType(argument)) and
       not istable(argument)
    then
        return true
    end


    if not istable(argument) then
        return false, "table expected, got " .. type(argument)
    end


    return IsColor(argument), "color expected, got " .. type(argument)
end)


RegisterType("team", function(argument, argumentData)
    if argument == nil and not argumentData.required then
        return true
    end


    if istable(argumentData.type) and 
       table.HasValue(argumentData.type, Arguments.DetectType(argument)) and
       not istable(argument)
    then
        return true
    end


    if not istable(argument) then
        return false, "table expected, got " .. type(argument)
    end


    return Utils.IsTeam(argument), "team expected, got " .. type(argument)
end)


RegisterType("language", function(argument, argumentData)
    if argument == nil and not argumentData.required then
        return true
    end
    

    if istable(argumentData.type) and 
       table.HasValue(argumentData.type, Arguments.DetectType(argument)) and
       not isstring(argument)
    then
        return true
    end
 

    if not isstring(argument) then
        return false, "string expected, got " .. type(argument)
    end


    return TeamMenu.Language.IsValid(argument), "invalid language"
end)


Utils.Accessor(self, "tbl", "Table", "table", true, true)
Utils.Accessor(self, "enabled", "Enabled", "boolean", true, true)
Utils.Accessor(self, "types", "Types", "table", true, true)


Utils.SetGlobalTable(nil)