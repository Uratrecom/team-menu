Uratrecom.Module("Uratrecom.TeamMenu.Events", Uratrecom.TeamMenu)


function CanCreateTeam(ply)
	return true
end


function TeamCreated(team_instance)
	Hook.Run("TeamCreated", team_instance)
end


function CanChangeTeam(ply, current, wanted)
	return true
end


function TeamChanged(old_team, new_team)
	Hook.Run("TeamChanged", old_team, new_team)
end


function CanRemoveTeam(ply, team_instance)
	return true
end


function TeamRemoved(team_instance)
	hook.Run("TeamRemoved", team_instance)
end


function CanLeaveTeam(ply, team_instance)
	return true
end


function LeaveTeam(ply)
	Hook.Run("TeamLeave", ply)
end


function CanUpdateTeam(ply, team_instance)
	return true
end


function TeamUpdated(team_instance, is_network_change)
	Hook.Run("TeamUpdated", team_instance, is_network_change)
end