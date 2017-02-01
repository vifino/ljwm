local xcb = require("xcb.wrapper")
local conn = xcb.connect()

local wid = conn:get_input_focus():reply(conn).focus

local wind = conn:window(wid)
print("Window:", wind)

print("Children:")
local children = wind:children()
for n, wid in pairs(children) do
	print("        "..tostring(wid))
end
