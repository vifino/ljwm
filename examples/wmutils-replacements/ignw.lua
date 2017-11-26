#!/usr/bin/env ljwm
-- Small wmutils ignw clone using ljwm

local args = {...}
local function usage()
	print("Usage: ignw [-sr] <wid> [wid..]")
	os.exit(1)
end

if #args == 0 then usage() end

local wids = {}
local setflag = false
for i=1, #args do
	local n = args[i]
	if n == "-s" then
		setflag = 1
	elseif n == "-r" then
		setflag = 0
	else
		table.insert(wids, assert(tonumber(n)))
	end
end

if #wids == 0 then usage() end

local xcb = require("xcb.wrapper")
local xcbe = require("xcb.enums")
local conn = xcb.connect()

for i=1, #wids do
	local wid = wids[i]
	local win = assert(conn:window(wid))

	win:change({override_redirect=setflag})
end

conn:disconnect()
