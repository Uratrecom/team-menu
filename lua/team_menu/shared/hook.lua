Uratrecom.Module("Uratrecom.TeamMenu.Hook", Uratrecom.TeamMenu)


AccessorFunc(self, "Hooks", "Hooks")
SetHooks(hook.GetTable())


function Anonymous(event, callback)
	local id = nil

	while Hooks[id] == nil do
		id = tostring(SysTime()) .. tostring(math.random()) .. tostring(os.clock())
	end

	hook.Add(PrefixId(event), id, callback)

	return id
end


function Add(event, id, callback)
	hook.Add(PrefixId(event), id, callback)
end


function Remove(event, id)
	hook.Remove(PrefixId(event), id)
end


function Run(event, ...)
	return hook.Run(PrefixId(event), ...)
end