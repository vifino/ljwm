-- This module is responsible for ensuring initially
--  mapped windows have a good position.
-- This involves keeping an internal set of positions,
--  and keeping track of how occupied they are.

-- For obvious reasons, it is the responsibility of anything overriding map_request
--  and performing reparenting to substitute the window passed for it's window,
--  or alternatively cancel the request at that point.

-- Map window IDs to positions.
local seen = {}

-- The amount of windows in a given position.
local lookup = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

return function(evtype, evdata, evsent)
	if evtype == "map_request" then
		local r, a = pcall(function()
			local c, p, r = connection:window(evdata.window):tree()
			return (p == r) and (r == screen.root)
		end)
		local should_nudge = true
		if not r then
			-- Window died.
			return false
		end
		if not a then
			-- Not relevant.
			should_nudge = false
		end
		local pos = 0
		if should_nudge then
			local lowestpos = 1
			local lowestcount = math.huge
			for i = 1, #lookup do
				if lookup[i] < lowestcount then
					lowestpos = i
					lowestcount = lookup[i]
				end
			end
			pos = lowestpos

			local cw = connection:window(evdata.window)
			cw:configure({
				x = pos * 32,
				y = pos * 32
			})
		end
		seen[evdata.window] = pos
		if pos ~= 0 then
			lookup[pos] = lookup[pos] + 1
		end
	end
	if evtype == "destroy_notify" then
		local b = seen[evdata.window]
		-- It's possible nudger never knew about the window,
		--  either because it predates initialization of the WM,
		--  or because it simply wasn't relevant.
		if b then
			if b ~= 0 then
				seen[evdata.window] = nil
				lookup[b] = lookup[b] - 1
			end
		end
	end
	return false
end
