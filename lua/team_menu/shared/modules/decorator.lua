Module("TeamMenu.Decorator")


local isfunction = _G.isfunction
local istable = _G.istable
local unpack = _G.unpack
local setmetatable = _G.setmetatable


local function GetWrapper(self, target, arguments)
    arguments = arguments or {}

    return function(...)
        if isfunction(self.Call) then
            if self.Call(arguments, { ... }) then
                return
            end
        end


        local result = { target(...) }


        if isfunction(self.Result) then
            local change, value = self.Result(arguments, result)

            if change then
                result = value
            end
        end


        return unpack(result)
    end
end


META = {}


function META.__concat(self, target)
	if isfunction(target) then		
		local func = GetWrapper(self, target, self.arguments)


		local decorator = self.leftDecorator


		while decorator do
			func = func .. decorator
			decorator = decorator.leftDecorator
            decorator.leftDecorator = nil
		end


        self.arguments = nil
        self.leftDecorator = nil


		return func
	end

	if istable(target) then
		target.leftDecorator = self
	end
end


function META.__call(self, ...)
	self.arguments = { ... }

	return self
end


function Create(tbl)
    return setmetatable(tbl, META)
end