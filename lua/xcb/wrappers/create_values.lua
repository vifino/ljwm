-- Provides an actual solid list of CW-indexes,
-- *in the order of application for the window-value-mask*.
-- Same goes for GC creation values, and presumably anything else with the same system.
local window_cw = {
	"back_pixmap",
	"back_pixel",
	"border_pixmap",
	"border_pixel",
	"bit_gravity",
	"win_gravity",
	"backing_store",
	"backing_planes",
	"backing_pixel",
	"override_redirect",
	"save_under",
	"event_mask",
	"dont_propagate",
	"colormap",
	"cursor"
}
local gc_cw = {
	"function",
	"plane_mask",
	"foreground",
	"background",
	"line_width",
	"line_style",
	"cap_style",
	"join_style",
	"fill_style",
	"fill_rule",
	"tile",
	"stipple",
	"tile_stipple_origin_x",
	"tile_stipple_origin_y",
	"font",
	"subwindow_mode",
	"graphics_exposures",
	"clip_origin_x",
	"clip_origin_y",
	"clip_mask",
	"dash_offset",
	"dash_list",
	"arc_mode"
}

local ffi = require("ffi")
local enums = require("xcb.enums")

local function handle_values(enumset, prefix, cw, values)
	local vals = {}
	local mask = 0
	for _, v in ipairs(cw) do
		if values[v] then
			mask = mask + enumset[prefix .. v:upper()]
			table.insert(vals, values[v])
		end
	end
	local vals_core = nil
	if #vals > 0 then
		vals_core = ffi.new("uint32_t[?]", #vals, vals)
	end
	return mask, vals_core
end

local workspace = {
	create_window_values = function (values) return handle_values(enums.xcb_cw_t, "XCB_CW_", window_cw, values) end,
	gc_values = function (values) return handle_values(enums.xcb_gc_t, "XCB_GC_", gc_cw, values) end
}

STP.add_known_function(workspace.create_window_values, "create_values.create_window_values")
STP.add_known_function(workspace.gc_values, "create_values.gc_values")

return workspace