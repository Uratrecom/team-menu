local PrefixId = Uratrecom.TeamMenu.PrefixId


local window = nil


concommand.Add(Uratrecom.TeamMenu.PrefixConVar("cl_menu"), function()
	if IsValid(window) then
		window:Close()
	end

	window = vgui.Create(PrefixId("Window"))
	window:Center()
	window:MakePopup()
end)