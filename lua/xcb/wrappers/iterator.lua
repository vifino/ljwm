--- Iterators loader and selector.
-- Given xcb's design, there are many different iterators and such.
-- So, we have a selector which selects an iterator given type.

local ffi = require("ffi")

--- Require helper.
local function req_iter(name)
	return require("xcb.wrappers.iterators."..name)
end

-- List of iters.
local iters = {
	xcb_screen_iterator_t = req_iter("screen"),
}

return function(obj)
	local iter
	for type_name, type_iter in pairs(iters) do
		if ffi.istype(type_name, obj) then
			iter = type_iter
			break
		end
	end
	assert(iter, "no known iter for "..tostring(ffi_type))
	return iter(obj)
end
