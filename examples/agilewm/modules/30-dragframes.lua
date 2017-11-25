-- 'dragframes': Sets up the default frame configuration to create
--                frames that can be moved about (but not resized),
--                and forces a reasonable margin size.
local precreated = {}
local createdframes = {}

local function handle_lmb_motion(w, evdata)
	if createdframes[w] == true then
		createdframes[w] = {evdata.event_x, evdata.event_y}
		return
	else
		local ofsx = evdata.event_x - createdframes[w][1]
		local ofsy = evdata.event_y - createdframes[w][2]
		createdframes[w] = {evdata.event_x - ofsx, evdata.event_y - ofsy}
		-- Move the window
		local fr = connection:window(w)
		local p = fr:get_geometry()
		fr:configure({
			x = p.x + ofsx,
			y = p.y + ofsy
		})
	end
end

return function(evtype, evdata, evsent)
	if evtype == "framer.precreate" then
		precreated[evdata.window] = true
		evdata.event_mask = bit.bor(evdata.event_mask, xcbe.event_mask.BUTTON_1_MOTION)
		evdata.margin.l = math.max(evdata.margin.l, 4)
		evdata.margin.u = math.max(evdata.margin.u, 32)
		evdata.margin.r = math.max(evdata.margin.r, 4)
		evdata.margin.d = math.max(evdata.margin.d, 4)
	end
	if evtype == "framer.precreate.cancel" then
		precreated[evdata.window] = nil
	end
	if evtype == "framer.create" then
		if precreated[evdata.window] then
			createdframes[evdata.frame] = true
		end
		precreated[evdata.window] = nil
	end
	if evtype == "framer.destroy" then
		createdframes[evdata.frame] = nil
	end
	if evtype == "motion_notify" then
		if createdframes[evdata.event] then
			if evdata.child == 0 then
				if bit.band(evdata.state, xcbe.button_mask["1"]) ~= 0 then
					handle_lmb_motion(evdata.event, evdata)
				end
			end
		end
	end
	return false
end
