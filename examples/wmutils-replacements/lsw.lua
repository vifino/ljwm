#!/usr/bin/env ljwm
-- Small wmutils lsw clone written using ljwm

local xcb = require("xcb.wrapper")
local xcbr = require("xcb.raw")

local flags = {
	all = false,
	show_hidden = false,
	show_ignored = false,
	root = false,
	only_root = false,
}

local function usage()
	printf("Usage: %s [-houra] [wid...]\n", arg[0])
	os.exit(1)
end

local argl = #arg
local wids = {}

if argl == 0 then
	flags.root = true
else
	for i=1, #arg do
		local elem = arg[i]
		if elem:sub(1,1) == "-" then -- rest are options
			local options = elem:sub(2)
			for oi=1, #options do
				local opt = options:sub(oi, oi)
				if opt == "a" then flags.all = true
				elseif opt == "u" then flags.show_hidden = true
				elseif opt == "o" then flags.show_ignored = true
				elseif opt == "r" then flags.only_root = true
				else usage() end
			end
		else -- should be WID
			table.insert(wids, elem)
		end
	end
end

local conn = xcb.connect()

local function get_root() -- sounds nasty.
	local root_wid
	for screen in conn:get_setup():setup_roots() do
		root_wid = screen.root
	end
	assert(root_wid, "failed to get root wid")
	return root_wid
end

if flags.only_root then
	print(conn:window(get_root()):fmt())
	os.exit()
end

if flags.root or (#wids == 0) then
	table.insert(wids, get_root())
end

local function should_list(window)
	local attrs = window:get_attributes():reply(conn)

	if flags.all then
		return true
	end

	local check_hidden = true
	local check_ignored = true
	if attrs.map_state ~= xcbr.XCB_MAP_STATE_VIEWABLE then -- hidden
		check_hidden = flags.show_hidden
	end
	if attrs.override_redirect == 0 then -- ignored
		check_ignored = flags.show_hidden
	end

	return check_hidden and check_ignored
end

for i=1, #wids do
	local window = conn:window(wids[i])
	local children = window:children()

	for ci=1, #children do
		local child = children[ci]

		if should_list(child) then
			print(child:fmt())
		end
	end
end
