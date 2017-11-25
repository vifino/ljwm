--- Wrappers around a XCB connection.
-- This is the main thing.

local ffi = require("ffi")
local xcbr = require("xcb.raw")
local xcbe = require("xcb.enums")

local c_window = require("xcb.wrappers.window")
local c_event = require("xcb.wrappers.event")
local c_gc = require("xcb.wrappers.gc")

local fns_conn = {
	--- Disconnects the XCB connection.
	disconnect = function(self)
		if self then
			self:flush(true)
			xcbr.xcb_disconnect(ffi.gc(self, nil))
		end
	end,
	--- Flushes stuff.
	-- @param sync Forces syncronous flush instead of async one.
	flush = function(self, sync)
		if sync then
			return xcbr.xcb_aux_sync(self)
		end
		return xcbr.xcb_flush(self)
	end,
	--- Checks if the connection has an error.
	has_error = function(self)
		return xcbr.xcb_connection_has_error(self) ~= 0
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

	--- Get the input focus.
	get_input_focus = function(self)
		return xcbr.xcb_get_input_focus(self):reply(self)
	end,
	get_input_focus_unchecked = function(self)
		return xcbr.xcb_get_input_focus_unchecked(self):reply(self)
	end,
	--- Set input focus.
	-- @param win The window to focus.
	-- @param revert_to A xcb.enums.input_focus value.
	set_input_focus = function(self, win, revert_to)
		return xcbr.xcb_set_input_focus(self, revert_to or xcbe.input_focus.NONE, win.id, xcbe.time.CURRENT_TIME)
	end,

	--- Wait for an event.
	wait_for_event = function(self)
		local event = xcbr.xcb_wait_for_event(self)
		if event ~= nil then
			ffi.gc(event, ffi.C.free)
			return c_event(event)
		end
		return
	end,
	poll_for_event = function(self)
		local event = xcbr.xcb_poll_for_event(self)
		if event ~= nil then
			ffi.gc(event, ffi.C.free)
			return c_event(event)
		end
		return
	end,

	--- Window object constructor for current connection.
	window = function(self, wid)
		return c_window(self, wid)
	end,
	gc = function(self, gid)
		return c_gc(self, gid)
	end,
}
ffi.metatype("xcb_connection_t", {__index=fns_conn})
