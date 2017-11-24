#!/usr/bin/env ljwm
-- Small wmutils wtp clone using ljwm

local args = {...}
if #args ~= 5 then
	print("Usage: wtp <x> <y> <w> <h> <wid>")
	os.exit(1)
end
local x, y, w, h, wid = unpack(args)

local xcb = require("xcb.wrapper")
local xcbe = require("xcb.enums")
local conn = xcb.connect()

local win = conn:window(wid)
win:configure({x=x, y=y, height=h, width=w})
conn:disconnect()
