#!/usr/bin/env ljwm
-- Small wmutils killw clone using ljwm

local args = {...}
local function usage()
	print("Usage: killw [-p] <wid> [wid..]")
	os.exit(1)
end

if #args == 0 then usage() end

local wids = {}
local parent = false
for i=1, #args do
	local n = args[i]
	if n == "-p" then
		parent = true
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

	if parent then win:kill_client()
	else win:destroy() end
end

conn:disconnect()
