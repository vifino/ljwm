--- Wrapper for XCB GC

local ffi = require("ffi")
local xcbr = require("xcb.raw")

local index = {
	poly_arc = function(self, window, arcs)
		local arcs_raw = ffi.new("xcb_arc_t[?]", #arcs, arcs)
		xcbr.xcb_poly_arc(self.conn, window, self.gcid, #arcs, arcs_raw)
	end,
	poly_rectangle = function(self, window, rects)
		local rects_raw = ffi.new("xcb_rectangle_t[?]", #rects, rects)
		xcbr.xcb_poly_rectangle(self.conn, window, self.gcid, #rects, rects_raw)
	end
}

local mt = {
	__index = index,
	__tostring = function(self)
		return "<gc "..fmtwid(self.gcid)..">"
	end,
}

--- Constructor for a window object given a GCID.
c_gc = function(conn, gcid)
	if type(gcid) ~= "cdata" then
		gcid = ffi.cast("xcb_gcontext_t", tonumber(gcid))
	end
	local gc = {
		["gcid"] = gcid,
		["conn"] = conn,
	}
	setmetatable(gc, mt)
	return gc
end

return c_gc
