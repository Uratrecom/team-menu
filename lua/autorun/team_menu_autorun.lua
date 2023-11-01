Uratrecom = Uratrecom or {}
Uratrecom.TeamMenu = Uratrecom.TeamMenu or {}


function Uratrecom.GetFiles(directory, path, extension)
	local stack = { directory }
	local tbl = {}

	while #stack ~= 0 do
		local item = stack[1]
		local files, directories = file.Find(item .. "/*", path or "LUA")

		for _, d in ipairs(directories) do
			table.insert(stack, item .. "/" .. d)
		end

		for _, f in ipairs(files) do
			if (extension and f:EndsWith(extension)) or not extension then
				table.insert(tbl, item .. "/" .. f)
			end
		end

		table.remove(stack, 1)
	end

	return tbl
end


function Uratrecom.Set(tbl, path, value)
    local keys = path:Split(".")

    for index, key in ipairs(keys) do
        key = tonumber(key, 10) ~= nil and tonumber(key, 10) or key

		if index == #keys then
			tbl[key] = value

			return value
		end

		if tbl[key] == nil then
			tbl[key] = {}
		end

        tbl = tbl[key]
	end
end


function Uratrecom.Get(tbl, path, default, set)
	if isnumber(path) then
		path = tostring(path)
	end

    local keys = path:Split(".")
	local value = tbl

    for index, key in ipairs(keys) do
        key = tonumber(key, 10) ~= nil and tonumber(key, 10) or key

        value = value[key]

		if not istable(value) and value ~= nil then
			return value
		end

        if value == nil then
			if default ~= nil and set then
                return Uratrecom.Set(tbl, path, default)
			end

            if default ~= nil then
                return default
            end

            return
        end

        if index == #keys then
            return value
        end
    end
end


function Uratrecom.Module(name, ...)
	local index_tables = { ... }
	local module_table = Uratrecom.Get(_G, name, {}, true)
	local metatable = getmetatable(module_table) or {}

	function metatable:__index(key)
		if key == "self" then
			return self
		end

		for _, tbl in ipairs(index_tables) do
			if tbl[key] ~= nil then
				return tbl[key]
			end
		end

		return _G[key]
	end

	setfenv(2, setmetatable(module_table, metatable))
end


-- if CLIENT then
-- concommand.Add("testt", function()
-- 	local frame = vgui.Create("DFrame")
-- 	local panel = frame:Add("Panel")

-- 	panel:Dock(FILL)
-- 	local i = 0

-- 	local line_wide = 32
-- 	local base_vertex = {
-- 		{
-- 			x = 0,
-- 			y = 0
-- 		},
-- 		{
-- 			x = 0,
-- 			y = 0
-- 		},
-- 		{
-- 			x = 0,
-- 			y = 0
-- 		},
-- 		{
-- 			x = 0,
-- 			y = 0
-- 		}
-- 	}

-- 	local start_x = 0
-- 	print(start_x)

-- 	function panel:Think()
-- 		start_x = -line_wide * (math.max(frame:GetWide(), frame:GetTall()) / line_wide)
-- 		print(start_x)
-- 	end
-- 	function panel:Paint(width, height)
-- 		local angle = math.sin(45/180*math.pi)*height

-- 		surface.SetDrawColor(0, 132, 255)
-- 		surface.DrawRect(0, 0, width, height)
-- 		surface.SetDrawColor(0, 0, 0, 2/3*255)

-- 		draw.NoTexture()


-- 		for x = start_x, width + line_wide, line_wide do
-- 			x = x + i

-- 			base_vertex[1].x = x
-- 			base_vertex[1].y = 0

-- 			base_vertex[2].x = x + line_wide / 2
-- 			base_vertex[2].y = 0
			
-- 			base_vertex[3].x = x + line_wide / 2 + angle
-- 			base_vertex[3].y = height
			
-- 			base_vertex[4].x = x + angle
-- 			base_vertex[4].y = height

-- 			surface.DrawPoly(base_vertex)
-- 		end

-- 		i = (i + -1/15)

-- 		if i > line_wide or i < -line_wide then
-- 			i = 0
-- 		end
-- 	end

-- 	frame:SetSize(400, 400)
-- 	frame:Center()
-- 	frame:MakePopup()
-- 	frame:SetSizable(true)
-- end, "9u", 0)

-- concommand.Add("testt2", function()
-- 	local frame = vgui.Create("DFrame")
-- 	local panel = frame:Add("Panel")

-- 	panel:Dock(FILL)

-- 	local vertex_count = math.Clamp(math.floor(999/2)*2, 4, 128)
-- 	local base_vertex = {
-- 		{
-- 			x = 0,
-- 			y = 0
-- 		},
-- 		{
-- 			x = 0,
-- 			y = 0
-- 		},
-- 		{
-- 			x = 0,
-- 			y = 0
-- 		}
-- 	}

-- 	surface.CreateFont("facegoi", {
-- 		size = 60
-- 	})

-- 	function panel:Paint(width, height)
-- 		surface.SetDrawColor(Color(255, 127, 0))
-- 		surface.DrawRect(0, 0, width, height)

-- 		draw.NoTexture()

-- 		local r = math.max(width, height)
-- 		local step = math.pi*2/vertex_count
-- 		local i = 0
-- 		local t = SysTime()

-- 		for n = 0, math.pi*2, step do
-- 			surface.SetDrawColor(i % 2 == 0 and Color(27, 0, 255) or Color(255, 127, 0))

-- 			base_vertex[1].x = math.sin(n + t) * r + width / 2
-- 			base_vertex[1].y = math.cos(n + t) * r + height / 2

-- 			base_vertex[2].x = math.sin(n + t) + width / 2
-- 			base_vertex[2].y = math.cos(n + t) + height / 2
			
-- 			base_vertex[3].x = math.sin(n + t + step) * r + width / 2
-- 			base_vertex[3].y = math.cos(n + t + step) * r + height / 2

-- 			surface.DrawPoly(base_vertex)

-- 			i = i + 1
-- 		end

-- 	end

-- 	frame:SetSize(400, 400)
-- 	frame:Center()
-- 	frame:MakePopup()
-- 	frame:SetSizable(true)
-- end, "9u", 0)
-- end

for _, file_path in pairs(Uratrecom.GetFiles("team_menu/shared", "LUA", ".lua")) do
	include(file_path)
	AddCSLuaFile(file_path)
end


for _, file_path in pairs(Uratrecom.GetFiles("team_menu/server", "LUA", ".lua")) do
	if SERVER then
		include(file_path)
	end
end


for _, file_path in pairs(Uratrecom.GetFiles("team_menu/client", "LUA", ".lua")) do
	AddCSLuaFile(file_path)

	if CLIENT then
		include(file_path)
	end
end