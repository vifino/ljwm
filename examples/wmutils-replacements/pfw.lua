#!/usr/bin/env ljwm
-- Small wmutils pfw clone using ljwm

local xcb = require("xcb.wrapper")
local conn = xcb.connect()
printf("0x%08x\n", conn:get_input_focus():reply(conn).focus)
