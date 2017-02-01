--- Wrapper for XCB window

local ffi = require("ffi")
local xcbr = require("xcbr")

-- TODO: Configuring

local index = {
	--- Destroy the window.
	destroy = function(self, conn)
		return xcbr.xcb_destroy_window(conn, self)
	end,
	destroy_checked = function(self, conn)
		return xcbr.xcb_destroy_window_checked(conn, self)
	end,
	--- Destroy the subwindows.
	destroy_subwindows = function(self, conn)
		return xcbr.xcb_destroy_subwindows(conn, self)
	end,
	destroy_subwindows_checked = function(self, conn)
		return xcbr.xcb_destroy_subwindows_checked(conn, self)
	end,

	--- Reparrent the window
	reparent = function(self, conn, parent, x, y)
		return xcbr.xcb_reparent_window(conn, self, parent, x, y)
	end,
	reparent_checked = function(self, conn, parent, x, y)
		return xcbr.xcb_reparent_window_checked(conn, self, parent, x, y)
	end,

	--- Show the window.
	map = function(self, conn)
		return xcbr.xcb_map_window(conn, self)
	end,
	map_checked = function(self, conn)
		return xcbr.xcb_map_window_checked(conn, self)
	end,
	--- Show the subwindows.
	map_subwindows = function(self, conn)
		return xcbr.xcb_map_subwindows(conn, self)
	end,
	map_subwindows_checked = function(self, conn)
		return xcbr.xcb_map_subwindows_checked(conn, self)
	end,

	--- Hide the window.
	unmap = function(self, conn)
		return xcbr.xcb_unmap_window(conn, self)
	end,
	unmap_checked = function(self, conn)
		return xcbr.xcb_unmap_window_checked(conn, self)
	end,
	--- Hide the subwindows.
	unmap_subwindows = function(self, conn)
		return xcbr.xcb_unmap_subwindows(conn, self)
	end,
	unmap_subwindows_checked = function(self, conn)
		return xcbr.xcb_unmap_subwindows_checked(conn, self)
	end,

	--- Get window attributes.
	get_attributes = function(self, conn)
		return xcbr.xcb_get_window_attributes(conn, self)
	end,
	get_attributes_unchecked = function(self, conn)
		return xcbr.xcb_get_window_attributes_unchecked(conn, self)
	end,
}

ffi.metatype("xcb_window_t", {__index=index})
