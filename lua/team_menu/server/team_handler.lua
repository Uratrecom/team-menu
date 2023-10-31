Uratrecom.Module("Uratrecom.TeamMenu.Team.Handler", Uratrecom.TeamMenu)


local handlers = {}


function GetTable()
    return handlers
end


function RegisterHandler(id, data)
    handlers[id] = data
end


function SetHandlerId(id)
    ConVars.SetString("handler", id)
end


function GetHandlerId()
    return ConVars.GetString("handler")
end


function Process(command, ...)
    local handler_data = handlers[GetHandlerId()]
    local handler_command = handler_data and handler_data[command] or nil

    if handler_command == nil then
        return false
    end

    return handler_command(...)
end


RegisterHandler("Sandbox", {
    ChangeTeam = function(ply, current_team, wanted_team)
        return true
    end,

    LeaveTeam = function(ply, current_team)
        return true
    end,

    CreateTeam = function(ply, team_instance)
        return true
    end,

    RemoveTeam = function(ply, team_instance)
        return false
    end
})


RegisterHandler("Strict", {
    ChangeTeam = function(ply, current_team, wanted_team)
        return false
    end,

    LeaveTeam = function(ply, current_team)
        return false
    end,

    CreateTeam = function(ply, team_instance)
        return false
    end,

    RemoveTeam = function(ply, team_instance)
        return false
    end
})


RegisterHandler("OnlyAdmin", {
    ChangeTeam = function(ply, current_team, wanted_team)
        return ply:IsAdmin()
    end,

    LeaveTeam = function(ply, current_team)
        return ply:IsAdmin()
    end,

    CreateTeam = function(ply, team_instance)
        return ply:IsAdmin()
    end,

    RemoveTeam = function(ply, team_instance)
        return ply:IsAdmin()
    end
})