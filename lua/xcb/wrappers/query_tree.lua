--- Wrappers around xcb_query_tree_cookie_t

local ffi = require("ffi")
local xcbr = require("xcb.raw")

local qt_mt = {
	--- Get the reply.
	-- @param conn The xcb connection.
	reply = function(self, conn, eptr)
		local reply = xcbr.xcb_query_tree_reply(conn, self, eptr)
		ffi.gc(reply, ffi.C.free)
		return reply
	end
}

ffi.metatype("xcb_query_tree_cookie_t", {__index=qt_mt})
