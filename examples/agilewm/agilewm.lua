-- ~~Test~~AgileWM: a 'window manager' for testing purposes.
-- This is as modular as you can get while calling it a 'WM' - on it's own,
--  it more or less acts as the "null window manager",
--  not bothering to do anything and passing through requests as given.

local args = {...}
for v in ipairs(args) do
	print("Module: " .. v)
end

-- First things first, do the initial connection,
-- if this fails there isn't any point wasting time loading modules

local xcb = require("xcb.wrapper")
local xcbe = require("xcb.enums")

local conn = xcb.connect()

-- Firstly, event transform/default behavior stuff
local function configure_request_svh(v, m, t)
	if bit.band(m, t) ~= 0 then
		return v
	end
end

local function pre_transform_event(ev)
	if ev.type == "configure_request" then
		-- A window wants to be configured,
		--  let's make that happen!
		local vl = {}
		local evcr = ev.configure_request
		local vm = evcr.value_mask
		vl.x = configure_request_svh(evcr.x, vm, xcbe.config_window.X)
		vl.y = configure_request_svh(evcr.y, vm, xcbe.config_window.Y)
		vl.width = configure_request_svh(evcr.width, vm, xcbe.config_window.WIDTH)
		vl.height = configure_request_svh(evcr.height, vm, xcbe.config_window.HEIGHT)
		vl.border_width = configure_request_svh(evcr.border_width, vm, xcbe.config_window.BORDER_WIDTH)
		vl.sibling = configure_request_svh(evcr.sibling, vm, xcbe.config_window.SIBLING)
		vl.stack_mode = configure_request_svh(evcr.stack_mode, vm, xcbe.config_window.STACK_MODE)
		return "configure_request", {
			window = evcr.window,
			parent = evcr.parent,
			values = vl}, ev.sendevent
	end
	return ev.type, ev[ev.type], ev.sendevent
end
local function post_transform_event(evtype, evdata, evsent)
	if evtype == "configure_request" then
		conn:window(evdata.window):configure(evdata.values)
	end
	if evtype == "map_request" then
		conn:window(evdata.window):map()
	end
end

-- Modules work in a similar way to Minetest - they all share one environment.
-- No true sandboxing is performed, it just keeps the modules from 
--  messing around with core or module instances in other screens.

-- Global environment variables (other than the normal ones) are:
-- xcb/xcbe: Libraries
-- connection: XCB Connection instance
-- submit_ev(evtype, evdata): Deliberately submit an event to the system,
--             in order to cause, ex. WM-created windows to be managed by the WM
--            Notably, event data can be of table format,
--             so long as the structure is kept consistent:
--             this should be kept under consideration when reading them.
-- screen: Screen-specific data

-- A module returns only one function,
--  the "event handler function".
-- This function receives three parameters:
--  the event type, event data, and if the event was caused by XSendEvent.
-- It can return true for the event to be stopped at that point, or false otherwise.
-- It is valid for the event data to be tampered with.

-- The event data can be cdata or a table,
--  so long as the fields are of precisely the correct format.
-- (For this format, please see the event structures involved,
--   and keep in mind resource IDs are not automatically wrapped.)

-- Some events may not actually be X window system events.

-- "init" carries no data, and is an initial bootstrap event
--  used after all modules have been instantiated.

-- "configure_request" has special handling that
--  transforms it into a value structure that can be passed
--  to configure - indeed, the default behavior without suppression
--  is to pass the (possibly transformed) configuration to configure.
-- Here's the structure (Note: 'sequence' & 'parent' do not affect the configuration.
--  Unsure why they exist. Maybe it's just an assist for the WM.
--  Notably, reparenting AFAIK *cannot be fully redirected*,
--   and there's no value_mask flag to set this as a reparenting.):
--  {sequence = <sequence>,
--   parent = <parent>,
--   window = <window>,
--   values = <configure value-set>}

local screens = {}

for screen in conn:get_setup():setup_roots() do
	-- Screens are handled on a per-root basis
	local env = {}
	for k, v in pairs(_G) do
		env[k] = v
	end
	env.xcb = xcb
	env.xcbe = xcbe
	env.connection = conn
	env.screen = screen
	local mdt = {}
	env.submit_ev = function (evtype, evdata, evsent)
		for _, v in ipairs(mdt) do
			if v(evtype, evdata, evsent) then
				return true
			end
		end
	end
	screens[screen.root] = env
	for k, v in ipairs(args) do
		local f, err = loadfile(v)
		if not f then error(err) end
		setfenv(f, env)
		mdt[k] = f()
	end
	local root = conn:window(screen.root)

	root:change({
		event_mask = 
		xcbe.event_mask.STRUCTURE_NOTIFY +
		xcbe.event_mask.SUBSTRUCTURE_NOTIFY +
		xcbe.event_mask.SUBSTRUCTURE_REDIRECT
	})
end

-- Flush the root eventmask changes...
conn:flush()

-- Get ready to distribute "init"...

-- Unsure how this should be written or if it should be moved into LJWM itself
local function try_get_field(struct, field)
	local s, r = pcall(function () return struct[field] end)
	if not s then return nil end
	return r
end
local function determine_window_root(evtype, evdata, evsent)
	-- Will either always return nil or always return something for
	--  a given event type, I think?
	local w = try_get_field(evdata, "window")
	if not w then
		return try_get_field(evdata, "root")
	end
	if w then
		local ok, res = pcall(function ()
			local c, p, r = conn:window(w):tree()
			return r
		end)
		if ok then
			return res
			-- otherwise, probably errored with
			-- "the window doesn't exist".
			-- why is this an error again?
		end
	end
end

local function distribute_event(evtype, evdata, evsent)
	local window_root = determine_window_root(evtype, evdata, evsent)
	if window_root then
		local p = screens[window_root]
		if p then
			if p.submit_ev(evtype, evdata, evsent) then
				conn:flush()
				return
			end
		end
	else
		for k, v in pairs(screens) do
			if v.submit_ev(evtype, evdata, evsent) then
				conn:flush()
				return
			end
		end
	end
	post_transform_event(evtype, evdata, evsent)
	conn:flush()
end

-- Kickstart modules.

distribute_event("init", {}, true)

-- The main event loop.

while true do
	local ev = conn:wait_for_event()
	if ev then
		if not ev.type then
			print("Dx ", ev.raw.response_type)
		else
			distribute_event(pre_transform_event(ev))
		end
	else
		error("Error.")
	end
end
