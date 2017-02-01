--- Wrapper for XCB window

local ffi = require("ffi")
local xcbr = require("xcb.raw")

-- TODO: Configuring

local index = {
	--- Destroy the window.
	destroy = function(self)
		return xcbr.xcb_destroy_window(self.conn, self.wid)
	end,
	destroy_checked = function(self)
		return xcbr.xcb_destroy_window_checked(self.conn, self.wid)
	end,
	--- Destroy the subwindows.
	destroy_subwindows = function(self)
		return xcbr.xcb_destroy_subwindows(self.conn, self.wid)
	end,
	destroy_subwindows_checked = function(self)
		return xcbr.xcb_destroy_subwindows_checked(self.conn, self.wid)
	end,

	--- Reparrent the window
	reparent = function(self, parent, x, y)
		return xcbr.xcb_reparent_window(self.conn, self.wid, parent, x, y)
	end,
	reparent_checked = function(self, parent, x, y)
		return xcbr.xcb_reparent_window_checked(self.conn, self.wid, parent, x, y)
	end,

	--- Show the window.
	map = function(self)
		return xcbr.xcb_map_window(self.conn, self.wid)
	end,
	map_checked = function(self)
		return xcbr.xcb_map_window_checked(self.conn, self.wid)
	end,
	--- Show the subwindows.
	map_subwindows = function(self)
		return xcbr.xcb_map_subwindows(self.conn, self.wid)
	end,
	map_subwindows_checked = function(self)
		return xcbr.xcb_map_subwindows_checked(self.conn, self.wid)
	end,

	--- Hide the window.
	unmap = function(self)
		return xcbr.xcb_unmap_window(self.conn, self.wid)
	end,
	unmap_checked = function(self)
		return xcbr.xcb_unmap_window_checked(self.conn, self.wid)
	end,
	--- Hide the subwindows.
	unmap_subwindows = function(self)
		return xcbr.xcb_unmap_subwindows(self.conn, self.wid)
	end,
	unmap_subwindows_checked = function(self)
		return xcbr.xcb_unmap_subwindows_checked(self.conn, self.wid)
	end,

	--- Get window attributes.
	get_attributes = function(self)
		return xcbr.xcb_get_window_attributes(self.conn, self.wid)
	end,
	get_attributes_unchecked = function(self)
		return xcbr.xcb_get_window_attributes_unchecked(self.conn, self.wid)
	end,
}

local mt = {
	__index=index,
	__tostring = function(self)
		return "<window "..io.format("0x%08x", self.wid)..">"
	end,
}

--- Constructor for a window object given a WID.
return function(conn, wid)
	local window = {
		["wid"] = wid,
		["conn"] = conn,
	}
	setmetatable(window, mt)
	return window
end
