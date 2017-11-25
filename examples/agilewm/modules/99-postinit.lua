-- postinit: Module responsible for post-initialization kickstart of the WM
-- (That is, causing map_requests on windows that have already been mapped)
-- Notably, this should be last!

local initmaps = {}

local function kick(w)
	local m = {window = w}
	local r = submit_ev("map_request", m, false)
	if not r then
		connection:window(m.window):map()
	end
end

return function (evtype, evdata, evsent)
	if evtype == "init" then
		for k, v in ipairs(connection:window(screen.root):children()) do
			local w = connection:window(v)
			local gwa = w:get_attributes()
			if gwa.map_state ~= xcbe.map_state.UNMAPPED then
				w:unmap()
				initmaps[w.id] = true
			end
		end
	end
	-- The reasoning here is that unmap_notify is going to occur 
	-- *once* no matter what.
	-- Best if the framing happens *afterwards*.
	if evtype == "unmap_notify" then
		if initmaps[evdata.window] then
			kick(evdata.window)
			initmaps[evdata.window] = nil
		end
	end
	return false
end
