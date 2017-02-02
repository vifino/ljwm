--- XCB API wrapper.
-- Probably very primitive.
-- They are designed to be small, raw. Simple abstraction to the commands to make it more OO and making the types less... scary.
-- Also incomplete. And maybe buggy.

local ffi = require("ffi")
local xcbr = require("xcb.raw")

-- Load the different wrappers
local wrappers = {
	"connection",
	"setup",
	"window",
	"window_attributes",
	"get_input_focus",
	"query_tree",
	"iterator",
}
for i=1, #wrappers do
	local wrapper = wrappers[i]
	require("xcb.wrappers."..wrapper)
end

local api = {
	--- Create an XCB connection.
	connect = function(display, screen, auth_info)
		if screen then screen = ffi.new("int[1]", screen) end
		local conn
		if auth_info then
			conn = xcbr.xcb_connect_to_display_with_auth_info(display, auth_info, screen)
		else
			conn = xcbr.xcb_connect(display, screen)
		end
		if conn:has_error() then
			error("xcb: unable to connect to X server.")
		end
		ffi.gc(conn, conn.disconnect)
		return conn
	end,
}

for i=1, #wrappers do
	local wrapper = wrappers[i]
	api[wrapper] = require("xcb.wrappers."..wrapper)
end

-- Stack traces.
STP.add_known_table(api, "xcb.wrapper library")

return api
