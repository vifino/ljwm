--- Wrapper for XCB GC

local ffi = require("ffi")
local xcbr = require("xcb.raw")
local c_window = require("xcb.wrappers.window")
local cv = require("xcb.wrappers.create_values")

local index = {
	poly_arc = function(self, window, arcs)
		local arcs_raw = ffi.new("xcb_arc_t[?]", #arcs, arcs)
		xcbr.xcb_poly_arc(self.conn, c_window(self.conn, window).id, self.id, #arcs, arcs_raw)
	end,
	poly_rectangle = function(self, window, rects)
		local rects_raw = ffi.new("xcb_rectangle_t[?]", #rects, rects)
		xcbr.xcb_poly_rectangle(self.conn, c_window(self.conn, window).id, self.id, #rects, rects_raw)
	end,
	create = function(self, drawable, values)
		local mask, vals_core = cv.create_gc_values(values)
		-- This one can't be dealt with by direct casting
		if type(drawable) == "table" then
			drawable = drawable.id
		end
		xcbr.xcb_create_gc(self.conn, self.id, drawable, mask, vals_core)
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
