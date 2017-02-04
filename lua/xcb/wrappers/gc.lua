--- Wrapper for XCB GC

local ffi = require("ffi")
local xcbr = require("xcb.raw")
local cv = require("xcb.wrappers.create_values")

local function drawable(d)
	-- This one can't be dealt with by direct casting
	if type(d) == "table" then
		return d.id
	end
	return d
end

local function generate_standard_poly_function(element, name, has_cmode)
	local f = xcbr[name]
	local ctp = ffi.typeof(element .. "[?]")
	if has_cmode then
		return function (self, window, coord_mode, elements)
			if elements[0] then error("Can't have a zero index in the array.") end
			local points_raw = ffi.new(ctp, #elements, elements)
			return f(self.conn, coord_mode, drawable(window), self.id, #elements, points_raw)
		end
	else
		return function (self, window, elements)
			if elements[0] then error("Can't have a zero index in the array.") end
			local points_raw = ffi.new(ctp, #elements, elements)
			return f(self.conn, drawable(window), self.id, #elements, points_raw)
		end
	end
end

local index = {
	poly_point = generate_standard_poly_function("xcb_point_t", "xcb_poly_point", true),
	poly_line = generate_standard_poly_function("xcb_point_t", "xcb_poly_line", true),
	poly_segment = generate_standard_poly_function("xcb_segment_t", "xcb_poly_segment", false),
	poly_rectangle = generate_standard_poly_function("xcb_rectangle_t", "xcb_poly_rectangle", false),
	poly_arc = generate_standard_poly_function("xcb_arc_t", "xcb_poly_arc", false),

	fill_poly = function (self, window, shape, coord_mode, elements)
		if points[0] then error("Can't have a zero index in the array.") end
		local points_raw = ffi.new(ctp, #points, points)
		return f(self.conn, drawable(window), self.id, shape, coord_mode, #points, points_raw)
	end,

	poly_fill_rectangle = generate_standard_poly_function("xcb_rectangle_t", "xcb_poly_fill_rectangle", false),
	poly_fill_arc = generate_standard_poly_function("xcb_arc_t", "xcb_poly_fill_arc", false),

	create = function(self, window, values)
		local mask, vals_core = cv.gc_values(values)
		xcbr.xcb_create_gc(self.conn, self.id, drawable(window), mask, vals_core)
	end,
	change = function(self, values)
		local mask, vals_core = cv.gc_values(values)
		xcbr.xcb_change_gc(self.conn, self.id, mask, vals_core)
	end,
}

local mt = {
	__index = index,
	__tostring = function(self)
		return "<gc "..fmtwid(self.id)..">"
	end,
}

--- Constructor for a GC object given a GCID.
c_gc = function(conn, gcid)
	if type(gcid) ~= "cdata" then
		if getmetatable(gcid) == mt then return gcid end
		gcid = ffi.cast("xcb_gcontext_t", tonumber(gcid))
	end
	local gc = {
		["id"] = gcid,
		["conn"] = conn,
	}
	setmetatable(gc, mt)
	return gc
end

STP.add_known_function(c_gc, "xcb.wrappers.gc constructor")

return c_gc
