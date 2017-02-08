local xcb = require("xcb.wrapper")
local xcbe = require("xcb.enums")

local conn = xcb.connect()

local screen = conn:get_setup():setup_roots()()

-- Test circle window
print("Creating window & GC")

local wind = conn:window(conn:generate_id())
local values = {
	back_pixel = screen.white_pixel,
	event_mask = xcbe.event_mask.EXPOSURE
}
wind:create(0, screen.root, 0, 0, 256, 256, 1, xcbe.window_class.INPUT_OUTPUT, screen.root_visual, values)
wind:map()

local gc = conn:gc(conn:generate_id())
gc:create(wind, {})

conn:flush()

print("Waiting for events")

while true do
	local ev = conn:wait_for_event()
	if ev then
		if ev.type == "expose" then
			local expose = ev.expose
			if expose.window == wind.id then
				print("Exposed, " .. expose.x .. " " .. expose.y .. " / " .. expose.width .. "x" .. expose.height)
				gc:poly_arc(wind, {
					{8, 8, 240, 240, 0, 360 * 64}
				})
				conn:flush()
			end
		end
	else
		print("Error.")
		return
	end
end
