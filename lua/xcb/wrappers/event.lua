-- Wraps a XCB event.
-- Notably, this should only be ever attached to one copy of the event.
local ffi = require("ffi")
local bit = require("bit")
local xcbr = require("xcb.raw")

local convert_otypname = {
	[2] = "key_press",
	[3] = "key_release",
	[4] = "button_press",
	[5] = "button_release",
	[6] = "motion_notify",
	[7] = "enter_notify",
	[8] = "leave_notify",
	[9] = "focus_in",
	[10] = "focus_out",
	[11] = "keymap_notify",
	[12] = "expose",
	[13] = "graphics_exposure",
	[14] = "no_exposure",
	[15] = "visibility_notify",
	[16] = "create_notify",
	[17] = "destroy_notify",
	[18] = "unmap_notify",
	[19] = "map_notify",
	[20] = "map_request",
	[21] = "reparent_notify",
	[22] = "configure_notify",
	[23] = "configure_request",
	[24] = "gravity_notify",
	[25] = "resize_request",
	[26] = "circulate_notify",
	[27] = "circulate_request",
	[28] = "property_notify",
	[29] = "selection_clear",
	[30] = "selection_request",
	[31] = "selection_notify",
	[32] = "colormap_notify", -- I really want to put a "u" on this. -20kdc
	[33] = "client_message",
	[34] = "mapping_notify",
	[35] = "ge_generic"
}
local convert_nametype = {}
for _, v in pairs(convert_otypname) do
	convert_nametype[v] = ffi.typeof("xcb_" .. v .. "_event_t *")
end
local function index(self, k)
	if convert_nametype[k] then
		return ffi.cast(convert_nametype[k], self.raw[0])[0]
	end
	return nil
end

local function c_event(ev)
	local event = {
		["raw"] = ffi.gc(ev, ffi.C.free),
		["type"] = convert_otypname[bit.band(0x7F, ev.response_type)]
	}
	setmetatable(event, {
		__index = index,
		__gc = lose_reference
	})
	return event
end


STP.add_known_function(c_event, "xcb.wrappers.event constructor")

return c_event