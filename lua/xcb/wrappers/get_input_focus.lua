--- Wrappers around xcb_get_input_focus_t

local ffi = require("ffi")
local xcbr = require("xcb.raw")

local gifc_mt = {
	reply = function(self, conn, eptr)
		local reply = xcbr.xcb_get_input_focus_reply(conn, self, eptr)
		ffi.gc(reply, ffi.C.free)
		return reply
	end
}

ffi.metatype("xcb_get_input_focus_cookie_t", {__index=gifc_mt})
