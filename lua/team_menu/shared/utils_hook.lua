local Utils = TeamMenu.Utils


Utils.hook = Utils.hook or Utils.ReferenceTable(hook)


Utils.SetGlobalTable(Utils.hook)


local hooksTable = hook.GetTable()


function Get(eventName, hookId)
    if not Utils.CheckArguments(eventName, hookId) then
        return
    end


    if not Utils.hook.Exists(eventName, hookId) then
        return
    end


    return hooksTable[eventName][hookId]
end


Utils.AddArguments(Get, {
    { name = "eventName", required = true, type = "string" },
    { name = "hookId", required = true, type = "string" }
})


function Exists(eventName, hookId)
    if not Utils.CheckArguments(eventName, hookId) then
        return
    end


    local eventHooks = hooksTable[eventName]


    return eventHooks and eventHooks[hookId]
end


Utils.AddArguments(Exists, {
    { name = "eventName", required = true, type = "string" },
    { name = "hookId", required = true, type = "string" }
})


function MultipleAdd(hooks)
    if not Utils.CheckArguments(hooks) then
        return
    end


    local hookFunction = nil


    for _, hookData in ipairs(hooks) do
        if isfunction(hookData) then
            hookFunction = hookData
        else    
            hook.Add(hookData.event, hookData.id, hookFunction)
        end
    end
end


Utils.AddArguments(MultipleAdd, {
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