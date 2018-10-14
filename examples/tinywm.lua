-- TinyWM clone in LJWM.

local xcb = require("xcb.wrapper")
local xcbe = require("xcb.enums")

local conn = xcb.connect()

local screen = conn:get_setup():setup_roots()()
local root = conn:window(screen.root)

conn:grab_key(root, true, {"2"}, false, true, true)
conn:grab_button(root, false, {"BUTTON_PRESS", "BUTTON_RELEASE"}, true, true, root, false, 1, {"1"})
conn:grab_button(root, false, {"BUTTON_PRESS", "BUTTON_RELEASE"}, true, true, root, false, 3, {"1"})

conn:flush()

local mt, ew

while true do
	local ev = conn:wait_for_event()
	if ev.type == "button_press" then
		local e = ev.data
		ew = conn:window(e.child)

		ew:configure({stack_mode = xcbe.stack_mode.ABOVE})
		local geom = ew:get_geometry()
		if e.detail == 1 then
			mt = 1
			ew:warp_pointer(0, 0)
		else
			mt = 3
			ew:warp_pointer(geom.width, geom.height)
		end
		conn:grab_pointer(root, false, {"BUTTON_RELEASE", "BUTTON_MOTION", "POINTER_MOTION_HINT"}, true, true, root)
		conn:flush()
		print("pointer grabbed")
	elseif ev.type == "motion_notify" then
		local ptr = conn:query_pointer(root)
		local geom = ew:get_geometry()
		local w, h = ptr.root_x, ptr.root_y
		if ptr.root_x + geom.width > screen.width_in_pixels then
			w = screen.width_in_pixels - geom.width
		end
		if ptr.root_y + geom.height > screen.height_in_pixels then
			h = screen.height_in_pixels - geom.height
		end

		if mt == 1 then
			ew:configure({
					x = w,
					y = h,
			})
		elseif mt == 3 then
			ew:configure({
					width = ptr.root_x - geom.x,
					height = ptr.root_y - geom.y,
			})
		end
		conn:flush()
		print("motion notify in mode " .. mt)
	elseif ev.type == "button_release" then
		conn:ungrab_pointer()
		conn:flush()
		print("pointer ungrabbed")
	end
end
