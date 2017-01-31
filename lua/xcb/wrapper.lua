--- XCB API wrapper.
-- Probably very primitive.
-- Also incomplete. And maybe buggy.

local ffi = require("ffi")
local xcbr = require("xcb.raw")

-- Load the different wrappers
local wrappers = {
	"connection",
	"setup",
	"window",
	"get_input_focus",
}
for i=1, #wrappers do
	local wrapper = wrappers[i]
	require("xcb.wrappers."..wrapper)
end

return {
	--- Create an XCB connection.
	connect = function(display, screen)
		if screen then screen = ffi.new("int[1]", screen) end
		local conn = xcbr.xcb_connect(display, screen)
		if conn:has_error() then
			error("xcb: unable to connect to X server.")
		end
		ffi.gc(conn, conn.disconnect)
		return connt
	end,
}
