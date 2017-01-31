--- XCB FFI bindings. Or something.
-- Pretty much no convenience here, bare interface.
-- Probably not that great quality.
-- Stole a lot of code from https://github.com/Wiladams/LJIT2XCB, err, i mean.. inspired by...
-- Many thanks! ;)

local ffi = require("ffi")

-- Since we are modularized, load the defs and what not.
require("xcb.ffi_cdefs")

local enums_t = require("xcb.proto_enums")
local enums = {}
for _, t in pairs(enums_t) do
	for k, v in pairs(t) do
		enums[k] = v
	end
end

local CNST = {
	-- some constants
	X_PROTOCOL = 11;
	X_PROTOCOL_REVISION = 0;
	X_TCP_PORT = 6000;
	XCB_CONN_ERROR = 1;
	XCB_CONN_CLOSED_EXT_NOTSUPPORTED = 2;
	XCB_CONN_CLOSED_MEM_INSUFFICIENT = 3;
	XCB_CONN_CLOSED_REQ_LEN_EXCEED = 4;
	XCB_CONN_CLOSED_PARSE_ERR = 5;
	XCB_CONN_CLOSED_INVALID_SCREEN = 6;
	XCB_CONN_CLOSED_FDPASSING_FAILED = 7;

	XCB_NONE = 0;
	XCB_COPY_FROM_PARENT = 0;
	XCB_CURRENT_TIME = 0;
	XCB_NO_SYMBOL = 0;
}

local _M = {}

local C = ffi.C

local function lookupInLibrary(key)
	local success, value = pcall(function() return C[key] end)

	if success then
		return value;
	end

	return nil;
end

local function lookupTypeName(key)
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

		-- look it up in the constants
		value = CNST[key]
		if value then
			rawset(self, key, value)
			return value;
		end

		-- look up enums
		value = enums[key]
		if value then
			rawset(self, key, value)
			return value
		end

		-- try looking in the library.	This will find functions
		-- and constants or return nil if not found
		value = lookupInLibrary(key)
		if value then
			rawset(self, key, value);
			return value;
		end

		-- Or maybe it's a type, use ffi.typeof
		value = lookupTypeName(key)
		if value then
			rawset(self, key, value);
			return value;
		end

		return nil;
	end,
})

return _M
