--- Wrappers around xcb_get_geometry_*_t

local ffi = require("ffi")
local xcbr = require("xcb.raw")

local gm_mt = {
	--- Get the reply.
	-- @param conn The xcb connection.
	reply = function(self, conn, eptr)
		local reply = xcbr.xcb_get_geometry_reply(conn, self, eptr)
		ffi.gc(reply, ffi.C.free)
		return reply
	end
}

ffi.metatype("xcb_get_geometry_cookie_t", {__index=gm_mt})
