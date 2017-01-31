-- LJWM: Library module loader

local submodules = {
	"utils"
}

local res = {}
for i=1, #submodules do
	local modname = submodules[i]
	res[modname] = require("ljwm."..modname)
end
return res
