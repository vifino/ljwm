--- Wrappers around xcb_get_window_attributes_*_t

local ffi = require("ffi")
local xcbr = require("xcb.raw")

local gwa_mt = {
	reply = function(self, conn, eptr)
		local reply = xcbr.xcb_get_window_attributes_reply(conn, self, eptr)
		ffi.gc(reply, ffi.C.free)
		return reply
	end
}

ffi.metatype("xcb_get_window_attributes_cookie_t", {__index=gwa_mt})
