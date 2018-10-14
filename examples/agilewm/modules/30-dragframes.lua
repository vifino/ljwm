-- 'dragframes': Sets up the default frame configuration to create
--                frames that can be moved about (but not resized),
--                and forces a reasonable margin size.
local precreated = {}
local createdframes = {}

return function(evtype, evdata, evsent)
	if evtype == "framer.precreate" then
		precreated[evdata.window] = true
		evdata.event_mask = bit.bor(evdata.event_mask, xcbe.event_mask.BUTTON_PRESS)
		evdata.margin.l = math.max(evdata.margin.l, 4)
		evdata.margin.u = math.max(evdata.margin.u, 4)
		evdata.margin.r = math.max(evdata.margin.r, 4)
		evdata.margin.d = math.max(evdata.margin.d, 4)
	elseif evtype == "framer.precreate.cancel" then
		precreated[evdata.window] = nil
	elseif evtype == "framer.create" then
		if precreated[evdata.window] then
			createdframes[evdata.frame] = evdata.window
		end
		precreated[evdata.window] = nil
	elseif evtype == "framer.destroy" then
		createdframes[evdata.frame] = nil
	elseif evtype == "button_press" then
		if createdframes[evdata.event] then
			if evdata.child == 0 then
				if evdata.detail == 1 or evdata.detail == 3 then
					local detail = evdata.detail
					local fr = connection:window(evdata.event)
					local wid = connection:window(createdframes[evdata.event])
					fr:configure({stack_mode = xcbe.stack_mode.ABOVE})
					local ox, oy = evdata.root_x, evdata.root_y
					local p = fr:get_geometry()
					local px, py, pw, ph = p.x, p.y, p.width, p.height
					grabber(function (x, y)
						if detail == 1 then
							fr:configure({
								x = px + x - ox,
								y = py + y - oy
							})
						else
							framer.change_frame(wid, p.x, p.y, pw + x - ox, ph + y - oy, false, false)
						end
					end)
					return true
				end
			end
		end
	end
	return false
end
