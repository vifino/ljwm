--- Wrapper for the XCB setup struct.

local ffi = require("ffi")
local xcbr = require("xcb.raw")
local iter = require("xcb.wrappers.iterators.screen")

local setup_t = {
	--- Get vendor.
	vendor = function(self)
		local char = xcbr.xcb_setup_vendor(self)
		local len = xcbr.xcb_setup_vendor_length(self)
		return ffi.string(char, len)
	end,

	--- Setup roots
	setup_roots = function(self)
		local iter_t = xcbr.xcb_setup_roots_iterator(self)
		return iter(iter_t)
	end,
}

ffi.metatype("xcb_setup_t", {__index=setup_t})
