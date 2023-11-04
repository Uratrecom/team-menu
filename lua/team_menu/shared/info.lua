Uratrecom.Module("Uratrecom.TeamMenu")


function GetVersion()
	return "0.0.0"
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
	return GetIdPrefix() .. "_" .. name
end