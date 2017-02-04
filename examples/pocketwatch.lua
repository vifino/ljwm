local xcb = require("xcb.wrapper")
local xcbe = require("xcb.enums")

-- Solely for sleep.
local ffi = require("ffi")
ffi.cdef("int usleep(unsigned int r);")
local usleep = ffi.C.usleep

local conn = xcb.connect()

local screen = conn:get_setup():setup_roots()()

-- Test circle window
print("Creating window & GC")

local wind = conn:window(conn:generate_id())
local values = {
	back_pixel = 0,
	event_mask = xcbe.xcb_event_mask_t.XCB_EVENT_MASK_EXPOSURE
}
wind:create(0, screen.root, 0, 0, 256, 256, 1, xcbe.xcb_window_class_t.XCB_WINDOW_CLASS_INPUT_OUTPUT, screen.root_visual, values)
wind:map()

local gc = conn:gc(conn:generate_id())
gc:create(wind, {
	foreground = 0x0000FF,
	line_style = xcbe.xcb_line_style_t.XCB_LINE_STYLE_SOLID
})

conn:flush()

print("Waiting for events")

local timeframe = 0
local truetimeepoch = os.time()
local lasttruetime = 0
local innerrotator = 0
local function drawhand(i, div, len)
	local ang = (((i % div) / div) * (math.pi * 2)) + math.pi
	local ox = math.floor(math.sin(-ang) * len)
	local oy = math.floor(math.cos(-ang) * len)
	gc:change({foreground = 0x0040FF, line_style = xcbe.xcb_line_style_t.XCB_LINE_STYLE_SOLID})
	gc:poly_line(wind, xcbe.xcb_coord_mode_t.XCB_COORD_MODE_ORIGIN, {
		{128, 128},
		{128 + ox, 128 + oy}
	})
end
local function redraw()
	local rects = {
		{0, 0, 256, 256}
	}
	gc:change({foreground = 0x000000})
	gc:poly_fill_rectangle(wind, rects)
	local circles = {}
	for i = 0, 32 do
		local margin = i * 4
		local a = i * 90
		if (i % 2) == 0 then
			a = a - timeframe
		else
			a = a + timeframe
		end
		local b = 90
		circles[i + 1] = {margin, margin, 255 - (margin * 2), 255 - (margin * 2), a * 64, b * 64}
	end
	gc:change({foreground = 0x0000FF, line_style = xcbe.xcb_line_style_t.XCB_LINE_STYLE_ON_OFF_DASH})
	gc:poly_arc(wind, circles)
	local truetime = os.time() - truetimeepoch
	if lasttruetime ~= truetime then
		innerrotator = 0
	end
	lasttruetime = truetime
	drawhand(truetime, 60, 66)
	drawhand(innerrotator, 20, 33)
	conn:flush()
end

while true do
	local ev = conn:poll_for_event()
	if ev then
		if ev.type == "expose" then
			local expose = ev.expose
			if expose.window == wind.id then
				print("Exposed, " .. expose.x .. " " .. expose.y .. " / " .. expose.width .. "x" .. expose.height)
				redraw()
			end
		end
	else
		usleep(50000)
		timeframe = timeframe + 1
		-- Goes up to ~20
		innerrotator = innerrotator + 1
		redraw()
	end
end
