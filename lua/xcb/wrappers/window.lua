--- Wrapper for XCB window

local ffi = require("ffi")
local xcbr = require("xcb.raw")

local cv = require("xcb.wrappers.create_values")

-- Helpers
local function fmtwid(wid)
	if type(wid) == "cdata" then wid = tonumber(wid) end
	return string.format("0x%08x", wid)
end

-- vars
local xcb_window_t = ffi.typeof("xcb_window_t")
local xcb_window_t_ptr = ffi.typeof("xcb_window_t*")
local xcb_window_t_ptr_ptr = ffi.typeof("xcb_window_t**")
local t_wid_size = ffi.sizeof(xcb_window_t)
local c_window

local index = {
	--- Get WID in string format.
	fmt = function(self)
		return fmtwid(self.id)
	end,
	--- Destroy the window.
	destroy = function(self)
		return xcbr.xcb_destroy_window(self.conn, self.id)
	end,
	destroy_checked = function(self)
		return xcbr.xcb_destroy_window_checked(self.conn, self.id)
	end,
	--- Destroy the subwindows.
	destroy_subwindows = function(self)
		return xcbr.xcb_destroy_subwindows(self.conn, self.id)
	end,
	destroy_subwindows_checked = function(self)
		return xcbr.xcb_destroy_subwindows_checked(self.conn, self.id)
	end,

	--- Reparrent the window
	reparent = function(self, parent, x, y)
		return xcbr.xcb_reparent_window(self.conn, self.id, c_window(self.conn, parent).id, x, y)
	end,
	reparent_checked = function(self, parent, x, y)
		return xcbr.xcb_reparent_window_checked(self.conn, self.id, c_window(self.conn, parent).id, x, y)
	end,

	--- Show the window.
	map = function(self)
		return xcbr.xcb_map_window(self.conn, self.id)
	end,
	map_checked = function(self)
		return xcbr.xcb_map_window_checked(self.conn, self.id)
	end,
	--- Show the subwindows.
	map_subwindows = function(self)
		return xcbr.xcb_map_subwindows(self.conn, self.id)
	end,
	map_subwindows_checked = function(self)
		return xcbr.xcb_map_subwindows_checked(self.conn, self.id)
	end,

	--- Hide the window.
	unmap = function(self)
		return xcbr.xcb_unmap_window(self.conn, self.id)
	end,
	unmap_checked = function(self)
		return xcbr.xcb_unmap_window_checked(self.conn, self.id)
	end,
	--- Hide the subwindows.
	unmap_subwindows = function(self)
		return xcbr.xcb_unmap_subwindows(self.conn, self.id)
	end,
	unmap_subwindows_checked = function(self)
		return xcbr.xcb_unmap_subwindows_checked(self.conn, self.id)
	end,

	--- Get window attributes.
	get_attributes = function(self)
		return xcbr.xcb_get_window_attributes(self.conn, self.id)
	end,
	get_attributes_unchecked = function(self)
		return xcbr.xcb_get_window_attributes_unchecked(self.conn, self.id)
	end,

	--- Get window geometry.
	-- Notably, this applies to any drawable.
	get_geometry = function(self)
		return xcbr.xcb_get_geometry(self.conn, self.id)
	end,
	get_geometry_unchecked = function(self)
		return xcbr.xcb_get_geometry_unchecked(self.conn, self.id)
	end,

	--- Get Children of a window.
	-- This method is sadly complicated.
	tree = function(self)
		local reply = xcbr.xcb_query_tree(self.conn, self.id):reply(self.conn)
		if reply == nil then
			error("window: no such window "..fmtwid(self.id))
		end
		local num_childs = reply.children_len
		local list = ffi.C.malloc(t_wid_size * num_childs)
		if not list then error("window: failed to allocate memory for children list buffer") end
		ffi.copy(list, xcbr.xcb_query_tree_children(reply), t_wid_size * num_childs)
		list = ffi.cast(xcb_window_t_ptr, list)

		local res = {}
		for i=1, num_childs do
			local child = list[i-1]
			res[i] = c_window(self.conn, tonumber(child))
		end
		ffi.C.free(list)
		return res, reply.parent, reply.root
	end,
	-- semi-alias to tree now
	children = function(self)
		local c, p, r = self:tree()
		return c
	end,
	create = function(self, depth, parent, x, y, width, height, border, class, visual, values)
		-- making this work correctly is done behind the scenes, i.e. here
		local mask, vals_core = cv.window_values(values)
		return xcbr.xcb_create_window(self.conn, depth, self.id, c_window(self.conn, parent).id, x, y, width, height, border, class, visual, mask, vals_core)
	end,
	change = function(self, values)
		local mask, vals_core = cv.window_values(values)
		return xcbr.xcb_change_window_attributes(self.conn, self.id, mask, vals_core)
	end,
	configure = function(self, values)
		local mask, vals_core = cv.config_values(values)
		return xcbr.xcb_configure_window(self.conn, self.id, mask, vals_core)
	end,
	-- Unsure what difference there is between this and configure.
	-- c. all the missing _checked functions
	configure_aux = function(self, values)
		local mask, vals_core = cv.config_values(values)
		return xcbr.xcb_configure_window(self.conn, self.id, mask, vals_core)
	end,
}

local mt = {
	__index = index,
	__tostring = function(self)
		return "<window "..fmtwid(self.id)..">"
	end,
}

--- Constructor for a window object given a WID.
c_window = function(conn, wid)
	if type(wid) == "table" then
		if getmetatable(wid) == mt then
			return wid
		else
			error("Incompatible wrapper passed to c_window.")
		end
	end
	local window = {
		["id"] = tonumber(wid),
		["conn"] = conn,
	}
	setmetatable(window, mt)
	return window
end

-- Stack trace info
STP.add_known_function(c_window, "xcb.wrappers.window constructor")

return c_window
