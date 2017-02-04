local xcb = require("xcb.wrapper")
local xcbe = require("xcb.enums")

local conn = xcb.connect()

local screen = conn:get_setup():setup_roots()()

-- Test circle window
print("Creating window & GC")

local wind = conn:window(conn:generate_id())
local values = {
	back_pixel = screen.white_pixel,
	event_mask = xcbe.xcb_event_mask_t.XCB_EVENT_MASK_EXPOSURE
}
conn:create_window(0, wind, screen.root, 0, 0, 256, 256, 1, xcbe.xcb_window_class_t.XCB_WINDOW_CLASS_INPUT_OUTPUT, screen.root_visual, values)
wind:map()

local gc = conn:gc(conn:generate_id())
wind:create_gc(gc, {})

conn:flush()

print("Waiting for events")

while true do
	local ev = conn:wait_for_event()
	if ev then
		if ev.type == "expose" then
			print("Exposed.")
			gc:poly_arc(wind, {
				{8, 8, 240, 240, 0, 360 * 64}
			})
			conn:flush()
		end
	else
		print("Error.")
		return
	end
end
