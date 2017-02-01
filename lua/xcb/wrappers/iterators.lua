--- Iterators loader.

local wrappers = {
	"generic",
}
for i=1, #wrappers do
	local wrapper = wrappers[i]
	require("xcb.wrappers.iterators."..wrapper)
end
