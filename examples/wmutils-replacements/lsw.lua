local xcb = require("xcb.wrapper")
local xcbr = require("xcb.raw")
local conn = xcb.connect()

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
	flags.all = true
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

local function get_root() -- sounds nasty.
	local root_wid
	print("uh oh, root wid")
	for screen in conn:get_setup():setup_roots() do
		print("l00p")
		root_wid = screen.root
	end
	print("after loop, help?")
	assert(root_wid, "failed to get root wid")
	return root_wid
end

if flags.only_root then
	print(conn:window(get_root()):fmt())
	os.exit()
end

if flags.root then
	table.insert(wids, get_root())
end

if #wids == 0 then
	usage()
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
	if attrs.override_redirect ~= 0 then -- ignored
		check_ignored = flags.show_hidden
	end

	return check_hidden and check_ignored
end

for i=1, #wids do
	print("ok, wid no. "..tostring(i))
	local window = conn:window(wids[i])
	print("got window. getting children")
	local children = window:children()
	
	print("looping over children")
	for ci=1, #children do
		local child = children[ci]

		if should_list(child) then
			print(child:fmt())
		end		
	end 
end
