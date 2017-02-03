local xcb = require("xcb.wrapper")
local xcbe = require("xcb.enums")

local conn = xcb.connect()

local screen = conn:get_setup():setup_roots()()

-- Test circle window
local wnd = conn:generate_id()
local values = {
	back_pixel = screen.white_pixel,
	event_mask = xcbe.xcb_event_mask_t.XCB_EVENT_MASK_EXPOSURE
}
print("Creating window")
conn:create_window(0, wnd, screen.root, 0, 0, 256, 256, 1, xcbe.xcb_window_class_t.XCB_WINDOW_CLASS_INPUT_OUTPUT, screen.root_visual, values)
print("Finishing")
local wind = conn:window(wnd)
wind:map()
conn:flush()
while true do
	local ev = conn:wait_for_event()
	if ev then
		if ev.type == "expose" then
			print("Exposed.")
			
		end
	else
		print("Error.")
		return
	end
end
