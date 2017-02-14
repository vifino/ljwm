-- Framer module
-- This module is responsible for giving frames to windows.

-- aframe maps frames to their window IDs (not window wrappers!)
-- frames maps windows to their frame window wrappers
-- margins specifies the margin data for a frame
-- both are indexed by ID for hopefully obvious reasons

-- All events added in order of occurrance:
--  framer.precreate
--   framer.precreate.cancel
--  framer.create
--  framer.config (this can be run many times)
--  framer.destroy

local aframe = {}
local frames = {}
local margins = {}

-- For some reason, windows reconfigure in screen coordinates,
-- BUT still respect the fact they're being reparented when specifying them?
local function reconfigure_frame(wrp, frame, evdata)
	local margin = margins[frame.id]
	if not margin then error("Somewhere, 'framer' lost track of the margin.") end
	
	local geom = frame:get_geometry():reply(connection)
	local posx = evdata.values.x or geom.x
	local posy = evdata.values.y or geom.y
	evdata.values.x = margin.l
	evdata.values.y = margin.u
	-- This just causes issues.
	evdata.values.border_width = 0
	local w = evdata.values.width or (geom.width - (margin.l + margin.r))
	local h = evdata.values.height or (geom.height - (margin.u + margin.d))
	local rcfg = {x = posx,
		y = posy,
		width = w + (margin.l + margin.r),
		height = h + (margin.u + margin.d)}
	frame:configure(rcfg)
	-- Notably, the reconfiguration cannot be stopped or altered,
	-- this just alerts modules which have their stuff on a frame.
	submit_ev("framer.config", {window = wrp.id, frame = frame.id, geom = rcfg}, false)
end
local function create_frame(wrp, margin, mask)
	local wind = connection:window(connection:generate_id())
	local values = {
		back_pixel = screen.white_pixel,
		event_mask = mask
	}
	local geom = wrp:get_geometry():reply(connection)
	local tx, ty, tw, th = geom.x - margin.l, geom.y - margin.u, geom.width + (margin.l + margin.r), geom.height + (margin.u + margin.d)
	wind:create(0, screen.root, tx, ty, tw, th, 0, xcbe.window_class.INPUT_OUTPUT, screen.root_visual, values)
	return wind
end
-- Passing "consultant" gives exclusive control of the frame's initial margin/mask set
--  to that function (which is called with the evdata of "framer.precreate"),
--  and doesn't run the framer.precreate or framer.create event submissions.
-- Thus, well-behaved modules should realize the frame wasn't ever created,
--  and leave it alone.
local function precreate_frame(wid, consultant)
	-- Only framer_precreate can be stopped - once the frame is created, the event sent is just a notification.
	-- Notably, this event doesn't care if window is changed,
	-- since that is probably a bad idea and shouldn't work.
	local redirection = {window = wid,
		margin = {l = 0, u = 0, r = 0, d = 0},
		event_mask =
		xcbe.event_mask.STRUCTURE_NOTIFY +
		xcbe.event_mask.SUBSTRUCTURE_NOTIFY +
		xcbe.event_mask.SUBSTRUCTURE_REDIRECT
	}
	if not consultant then
		if submit_ev("framer.precreate", redirection, false) then
			if submit_ev("framer.precreate.cancel", redirection, false) then
				error("The precreate cancel event should not be cancelled.")
			end
			-- we're not allowed to create the frame, apparently.
			return
		end
	else
		consultant(redirection)
	end
	-- Ok, so given no frame exists, and nothing's saying otherwise,
	--  a frame has to be created.
	-- (And then that frame mapped instead.)
	local wrp = connection:window(wid)
	local frame = create_frame(wrp, redirection.margin, redirection.event_mask)
	wrp:reparent(frame, redirection.margin.l, redirection.margin.u)
	wrp:configure({border_width = 0})
	wrp:map()
	frames[wid] = frame
	margins[frame.id] = redirection.margin
	aframe[frame.id] = wid
	if not consultant then
		-- At this point the margin should be considered read-only.
		-- It isn't, but it should be considered that way.
		submit_ev("framer.create", {window = wid, frame = frame.id, margin = redirection.margin}, false)
	end
	return frame.id
end
-- Warning: If used carelessly, this may destroy the window.
-- Ensure the window is already gone (destroyed or reparented away) before use.
-- Also ensure a notification has been received for the window's destruction,
--  if the frame was created by the normal method.
local function destroy_frame(wid)
	if frames[wid] then
		local frame = frames[wid]
		submit_ev("framer.destroy", {window = wid, frame = frame}, false)
		aframe[frame.id] = nil
		margins[frame.id] = nil
		frame:destroy()
		frames[wid] = nil
	end
end
-- API stuff --

framer = {}
framer.precreate_frame = precreate_frame
framer.destroy_frame = destroy_frame

local function map_request(w)
	if aframe[w] then
		-- Just in case.
		return w
	end
	if frames[w] then
		-- Ensure the window is mapped
		connection:window(w):map()
		-- and make the request to be to map the frame instead
		return frames[w].id
	end
	local a, b = pcall(function()
		local c, p, r = connection:window(w):tree()
		return (p == r) and (r == screen.root)
	end)
	if a and b then
		return (precreate_frame(w) or w)
	end
	return w
end

return function (evtype, evdata, evsent)
	if evtype == "map_request" then
		evdata.window = map_request(evdata.window)
		return false
	end
	if evtype == "configure_request" then
		if frames[evdata.window] then
			local wrp = connection:window(evdata.window)
			local frame = frames[evdata.window]
			-- This modifies evdata to remove X/Y changes & such
			reconfigure_frame(wrp, frame, evdata)
		end
		return false
	end
	-- This can be spuriously generated if a window was already mapped.
	-- Keep that in mind.
	if evtype == "unmap_notify" then
		if frames[evdata.window] then
			frames[evdata.window]:unmap()
		end
		return false
	end
	-- Notably, suppressing this, in any module, is usually a bad idea.
	-- (Not that you can't. It's just a bad idea.)
	if evtype == "destroy_notify" then
		-- This ignores invalid input
		destroy_frame(evdata.window)
		return false
	end
end
