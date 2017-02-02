local xcb = require("xcb.wrapper")
local conn = xcb.connect()

local wid
if arg[1] then
	wid = tonumber(arg[1])
else
	wid = conn:get_input_focus():reply(conn).focus
end

local wind = conn:window(wid)
print("Window:", wind)

print("Children:")
local children = wind:children()
for n, wid in pairs(children) do
	print("        "..tostring(wid))
end
