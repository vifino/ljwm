#!/usr/bin/env ljwm
-- Small wmutils wmv clone using ljwm

local args = {...}
if #args ~= 3 and #args ~= 4 then
	print("Usage: wmv [-a] <x> <y> <wid>")
	os.exit(1)
end
local parsed_args = {}
local absolute = false
for i=0, #args do
	local n = args[i]
	if n == "-a" then
		absolute = true
	else
		table.insert(parsed_args, n)
	end
end
local x, y, wid = unpack(parsed_args)

local xcb = require("xcb.wrapper")
local xcbe = require("xcb.enums")
local conn = xcb.connect()

local win = conn:window(wid)
local geom = win:get_geometry()

-- get screen
local setup = conn:get_setup()
local screen = setup:setup_roots()()

local vals = {}
if absolute then -- middle, not top left?
	x = x - geom.x + geom.width  /2
	y = y - geom.y + geom.height /2
end
vals.x = (x ~= 0) and (geom.x + x) or geom.x
vals.y = (y ~= 0) and (geom.y + y) or geom.y

if x ~= 0 then
	local real = geom.width + geom.border_width*2
	local pos = geom.x + x
	if pos < 1 then vals.x = 0 end
	local max = screen.width_in_pixels - real
	if pos > max then vals.x = max end
end

if y ~= 0 then
	local real = geom.height + geom.border_width*2
	local pos = geom.y + y
	if pos < 1 then vals.y = 0 end
	local max = screen.height_in_pixels - real
	if pos > max then vals.y = max end
end

win:teleport(vals.x, vals.y)
conn:disconnect()
