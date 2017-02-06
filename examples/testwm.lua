-- TestWM: a 'window manager' for testing purposes.
-- Only operates on one screen and doesn't do anything there,
--  apart from forwarding the requests it receives correctly.
-- Could be used as a base for a truly modular window manager.

local xcb = require("xcb.wrapper")
local xcbe = require("xcb.enums")

local conn = xcb.connect()

local screen = conn:get_setup():setup_roots()()
local root = conn:window(screen.root)

root:change({
	event_mask = 
	xcbe.xcb_event_mask_t.XCB_EVENT_MASK_STRUCTURE_NOTIFY +
	xcbe.xcb_event_mask_t.XCB_EVENT_MASK_SUBSTRUCTURE_NOTIFY +
	xcbe.xcb_event_mask_t.XCB_EVENT_MASK_SUBSTRUCTURE_REDIRECT
})
conn:flush()

local function configure_request_svh(v, m, t)
	if bit.band(m, t) ~= 0 then
		return v
	end
end

while true do
	local ev = conn:wait_for_event()
	if ev then
		print(ev.type)
		if ev.type == "configure_request" then
			-- A window wants to be configured,
			--  let's make that happen!
			local vl = {}
			local vm = ev.configure_request.value_mask
			vl.x = configure_request_svh(ev.configure_request.x, vm, xcbe.xcb_config_window_t.XCB_CONFIG_WINDOW_X)
			vl.y = configure_request_svh(ev.configure_request.y, vm, xcbe.xcb_config_window_t.XCB_CONFIG_WINDOW_Y)
			vl.width = configure_request_svh(ev.configure_request.width, vm, xcbe.xcb_config_window_t.XCB_CONFIG_WINDOW_WIDTH)
			vl.height = configure_request_svh(ev.configure_request.height, vm, xcbe.xcb_config_window_t.XCB_CONFIG_WINDOW_HEIGHT)
			vl.border_width = configure_request_svh(ev.configure_request.border_width, vm, xcbe.xcb_config_window_t.XCB_CONFIG_WINDOW_BORDER_WIDTH)
			vl.sibling = configure_request_svh(ev.configure_request.sibling, vm, xcbe.xcb_config_window_t.XCB_CONFIG_WINDOW_SIBLING)
			vl.stack_mode = configure_request_svh(ev.configure_request.stack_mode, vm, xcbe.xcb_config_window_t.XCB_CONFIG_WINDOW_STACK_MODE)
			conn:window(ev.configure_request.window):configure(vl)
			conn:flush()
		end
		if ev.type == "map_request" then
			conn:window(ev.map_request.window):map()
			conn:flush()
		end
	else
		error("Error.")
	end
end
