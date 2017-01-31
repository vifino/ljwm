--- Wrapper for the XCB setup struct.

local ffi = require("ffi")
local xcbr = require("xcb.raw")

local setup_t = {
	vendor = function(self)
		local char = xcbr.xcb_setup_vendor(self)
		local len = xcbr.xcb_setup_vendor_length(self)
		return ffi.string(char, len)
	end
}

ffi.metatype("xcb_setup_t", {__index=setup_t})
