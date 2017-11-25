#!/usr/bin/env ljwm
-- Small wmutils mapw clone using ljwm

local args = {...}
local function usage()
	print("Usage: mapw [-mut] <wid> [wid..]")
	os.exit(1)
end

if #args == 0 then usage() end

local wids = {}
local op = "map"
for i=1, #args do
	local n = args[i]
	if n:sub(1,1) == "-" then
		local c = n:sub(2)
		if c == "m" then op = "map"
		elseif c == "u" then op = "unmap"
		elseif c == "t" then op = "toggle"
		else
			usage()
		end
	else
		table.insert(wids, assert(tonumber(n)))
	end
end

local xcb = require("xcb.wrapper")
local xcbe = require("xcb.enums")
local conn = xcb.connect()

for i=1, #wids do
	local wid = wids[i]
	local win = assert(conn:window(wid))

	if op == "map" then win:map()
	elseif op == "unmap" then win:unmap()
	elseif op == "toggle" then
		if win:mapped() then
			win:unmap()
		else
			win:map()
		end
	end
end

conn:disconnect()
