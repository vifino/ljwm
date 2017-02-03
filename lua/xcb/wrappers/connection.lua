--- Wrappers around a XCB connection.
-- This is the main thing.

local ffi = require("ffi")
local xcbr = require("xcb.raw")
local enums = require("xcb.enums")

local c_window = require("xcb.wrappers.window")
local c_event = require("xcb.wrappers.event")

local window_cw = require("xcb.wrappers.window_cw")

local fns_conn = {
	--- Disconnects the XCB connection.
	disconnect = function(self)
		if self then
			xcbr.xcb_disconnect(ffi.gc(self, nil))
		end
	end,
	--- Flushes stuff.
	-- @param sync Forces syncronous flush instead of async one.
	flush = function(self, sync)
		if sync then
			return xcb.xcb_aux_flush(self)
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
		return xcbr.xcb_get_input_focus(self)
	end,
	get_input_focus_unchecked = function(self)
		return xcbr.xcb_get_input_focus_unchecked(self)
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
	create_window = function(self, depth, wind, parent, x, y, width, height, border, class, visual, values)
		-- making this work correctly is done behind the scenes, i.e. here
		local vals = {}
		local mask = 0
		for _, v in ipairs(window_cw) do
			if values[v] then
				mask = mask + enums.xcb_cw_t["XCB_CW_".. v:upper()]
				table.insert(vals, values[v])
			end
		end
		local vals_core = nil
		if #vals > 0 then
			vals_core = ffi.new("uint32_t[?]", #vals, vals)
		end
		xcbr.xcb_create_window(self, depth, wind, parent, x, y, width, height, border, class, visual, mask, vals_core)
	end,
}
ffi.metatype("xcb_connection_t", {__index=fns_conn})
