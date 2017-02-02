--- XCB FFI bindings. Or something.
-- Pretty much no convenience here, bare interface.
-- Probably not that great quality.
-- Contains some code from https://github.com/Wiladams/LJIT2XCB
-- Many thanks! ;)

local ffi = require("ffi")

-- Since we are modularized, load the defs and what not.
require("xcb.ffi_cdefs")

local _M = {}

local C = ffi.C

local function lookup_val(key)
	local success, value = pcall(function() return C[key] end)

	if success then
		return value;
	end

	return nil;
end

local function lookup_type(key)
	local success, value = pcall(function() return ffi.typeof(key) end)

	if success then
		return value;
	end

	return nil;
end

setmetatable(_M, {
	__index = function(self, key)
		local value = nil;
		local success = false;

		-- try looking in the c namespace. This will find functions,
		-- enums and constants or return nil if not found
		value = lookup_val(key)
		if value then
			rawset(self, key, value);
			return value;
		end

		-- Or maybe it's a type, use ffi.typeof
		value = lookup_type(key)
		if value then
			rawset(self, key, value);
			return value;
		end

		return nil;
	end,
})

-- Stack traces.
STP.add_known_table(_M, "xcb.raw library")

return _M
