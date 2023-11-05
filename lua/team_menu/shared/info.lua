Uratrecom.Module("Uratrecom.TeamMenu")


function GetName()
	return "Team menu"
end


function GetVersion()
	return "0.5B"
end


function GetConVarPrefix()
	return "team_menu"
end


function PrefixConVar(name)
	return GetConVarPrefix() .. "_" .. name
end


function GetIdPrefix()
	return "Uratrecom_TeamMenu"
end


function PrefixId(id)
	return GetIdPrefix() .. "_" .. id
end