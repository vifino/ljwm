-- LJWM default bootscript
-- Loads files and what not.

local fname = arg[1]
if not fname then
	print("Usage: ljwm file.lua [args..]")
	os.exit(1)
end
table.remove(arg, 1)

ljwm = require("ljwm")

local f, err = loadfile(fname)
if err then
	print("Compilation error: "..err)
end

local success, err = xpcall(f, debug.traceback)
if not success then
	print(err)
end
