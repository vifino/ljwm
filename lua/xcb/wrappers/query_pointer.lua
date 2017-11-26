--- Wrappers around xcb_query_pointer_*_t

local ffi = require("ffi")
local xcbr = require("xcb.raw")

local gm_mt = {
	--- Get the reply.
	-- @param conn The xcb connection.
	reply = function(self, conn, eptr)
		local reply = xcbr.xcb_query_pointer_reply(conn, self, eptr)
		ffi.gc(reply, ffi.C.free)
		return reply
	end
}

ffi.metatype("xcb_query_pointer_cookie_t", {__index=gm_mt})
