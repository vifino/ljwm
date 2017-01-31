--- Wrappers around a XCB connection.

local ffi = require("ffi")
local xcbr = require("xcb.raw")

local fns_conn = {
	--- Disconnects the XCB connection.
	disconnect = function(self)
		if self.conn then
			xcbr.xcb_disconnect(ffi.gc(self.conn, nil))
		end
	end,
	--- Flushes stuff.
	flush = function(self)
		return xcbr.xcb_flush(conn)
	end,
	--- Checks if the connection has an error.
	has_error = function(self)
		return xcbr.xcb_connection_has_error(self.conn) ~= 0
	end,
	--- Generate an ID.
	generate_id = function(self)
		return xcbr.xcb_generate_id(self)
	end,
	--- Get the FD of the connection.
	get_file_descriptor = function(self)
		return xcbr.xcb_get_file_descriptor(self)
	end,

	--- Get the setup.
	get_setup = function(self)
		return xcbr.xcb_get_setup(self)
	end,

	get_input_focus = function(self)
		return xcbr.xcb_get_input_focus(self)
	end,
	get_input_focus_unchecked = function(self)
		return xcbr.xcb_get_input_focus_unchecked(self)
	end,
}
ffi.metatype("xcb_connection_t", {__index=fns_conn})
