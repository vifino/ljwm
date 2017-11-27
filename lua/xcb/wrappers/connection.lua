--- Wrappers around a XCB connection.
-- This is the main thing.

local ffi = require("ffi")
local xcbr = require("xcb.raw")
local xcbe = require("xcb.enums")

local cv = require("xcb.wrappers.create_values")
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

	--- Get pointer information
	-- @param win Window to use as reference instead of the first screen.
	query_pointer = function(self, win)
		local root = win and win.id or self:get_setup():setup_roots()().root
		return xcbr.xcb_query_pointer(self, root):reply(self)
	end,
	query_pointer_unchecked = function(self, win)
		local root = win and win.id or self:get_setup():setup_roots()().root
		return xcbr.xcb_query_pointer_unchecked(self, root):reply(self)
	end,

	--- Warp the pointer.
	-- @param x X coordinate
	-- @param y Y coordinate
	-- @param absolute Optionally specify whether the position is absolute instead of relative. First screen is used as reference if multiple are present.
	-- @param win Optionally use a window as reference instead of the root window. Absolute must be falsey for it to have any effect.
	warp_pointer = function(self, x, y, absolute, win)
		local dst = win and win.id
		if absolute then
			local scr = self:get_setup():setup_roots()()
			dst = scr.root
		end
		return xcbr.xcb_warp_pointer(self, xcbe.none, dst or xcbe.none, 0,0, 0,0, x,y)
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

	--- Grab keyboard key(s).
	-- @param win Window.
	-- @param mods Array of Modifiers.
	-- @param key Keycode of the key to grab.
	-- @param owner_events Whether the win will still get pointer events.
	-- @param pointer_mode_async State that the pointer processing continues normally instead of freezing all pointer events until the grab is released.
	-- @param keyboard_mode_async State that the keyboard processing continues normally instead of freezing all keyboard events until the grab is released.
	grab_key = function(self, win, mods, key, owner_events, pointer_mode_async, keyboard_mode_async)
		local mod_mask = cv.mod_mask(mods)
		return xcbr.xcb_grab_key(self, owner_events and 1 or 0, win and win.id or xcbe.none, mod_mask, key, pointer_mode_async and xcbe.grab_mode.async or xcbe.grab_mode.sync, keyboard_mode_async and xcbe.grab_mode.async or xcbe.grab_mode.sync)
	end,

	--- Window object constructor for current connection.
	window = function(self, wid)
		return c_window(self, wid)
	end,
	--- GC object constructor for current connection.
	gc = function(self, gid)
		return c_gc(self, gid)
	end,
}
ffi.metatype("xcb_connection_t", {__index=fns_conn})
