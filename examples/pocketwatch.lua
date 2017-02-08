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
	event_mask = xcbe.event_mask.EXPOSURE
}
wind:create(0, screen.root, 0, 0, 256, 256, 8, xcbe.window_class.INPUT_OUTPUT, screen.root_visual, values)
wind:map()

local gc = conn:gc(conn:generate_id())
gc:create(wind, {
	foreground = 0x0000FF,
	line_style = xcbe.line_style.STYLE_SOLID
})

conn:flush()

print("Waiting for events")

local timeframe = 0
local lasttruetime = 0
local innerrotator = 0

local multipliers = {}
for i = 0, 32 do
	multipliers[i] = math.random() * 8
end

local function drawhand(i, div, len, fg)
	local ang = (((i % div) / div) * (math.pi * 2)) + math.pi
	local ox = math.floor(math.sin(-ang) * len)
	local oy = math.floor(math.cos(-ang) * len)
	gc:change({foreground = fg, line_style = xcbe.line_style.SOLID})
	gc:poly_line(wind, xcbe.coord_mode.ORIGIN, {
		{128, 128},
		{128 + ox, 128 + oy}
	})
end

local function redraw(size)
	gc:change({foreground = 0x000000})
	gc:poly_fill_rectangle(wind, {{0, 0, size, size}})
	local rgb = 0x001010
	local ad = 360 - ((os.time() % (3600 * 24)) / (10 * 24))
	for ic = 0, 3 do
		gc:change({foreground = rgb})
		local ml = 8
		local m = 128 - (4 * ml) + (ic * ml)
		local h = size - (1 + (m * 2))
		gc:poly_fill_arc(wind, {
			{m, m, h, h, 90 * 64, ad * 64}
		})
		rgb = rgb + 0x001020
	end

	local circles = {}
	for i = 0, 32 do
		local margin = i * 4
		local a = i * 90
		if (i % 2) == 0 then
			a = a - (timeframe * multipliers[i])
		else
			a = a + (timeframe * multipliers[i])
		end
		local b = 90
		local h = size - (1 + (margin * 2))
		circles[i + 1] = {margin, margin, h, h, a * 64, b * 64}
	end
	gc:change({foreground = 0x0000FF, line_style = xcbe.line_style.ON_OFF_DASH})
	gc:poly_arc(wind, circles)
	local truetime = os.time()
	if lasttruetime ~= truetime then
		innerrotator = 0
	end
	lasttruetime = truetime
	drawhand(truetime / 60, 60, math.floor(size / 4), 0x0010FF)
	drawhand(truetime, 60, math.floor(size / 16) * 3, 0x0040FF)
	drawhand(innerrotator, 20, math.floor(size / 6), 0x0080FF)
	conn:flush()
end

while true do
	local ev = conn:poll_for_event()
	if ev then
		if ev.type == "expose" then
			local expose = ev.expose
			if expose.window == wind.id then
				print("Exposed, " .. expose.x .. " " .. expose.y .. " / " .. expose.width .. "x" .. expose.height)
				redraw(256)
			end
		end
	else
		usleep(50000)
		timeframe = timeframe + 1
		-- Goes up to ~20
		innerrotator = innerrotator + 1
		redraw(256)
	end
end
