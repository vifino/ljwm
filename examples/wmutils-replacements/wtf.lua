#!/usr/bin/env ljwm
-- Small wmutils wtf clone using ljwm 

local args = {...}
if not args[1] then
	print("Usage: wtf <wid>")
	os.exit(1)
end

local xcb = require("xcb.wrapper")
local xcbe = require("xcb.enums")
local conn = xcb.connect()

local win = conn:window(args[1])
conn:set_input_focus(win, xcbe.input_focus.POINTER_ROOT)
conn:disconnect()
