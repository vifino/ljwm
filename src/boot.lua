-- LJWM default bootscript
-- Loads files and what not.

local args = arg
arg = nil

local fname = table.remove(args, 1)
if not fname then
	print("Usage: ljwm file.lua [args..]")
	os.exit(1)
end

ljwm = require("ljwm")

local f, err = loadfile(fname)
if err then
	print("Compilation error: "..err)
end

local success, err = xpcall(f, STP.stacktrace, unpack(args))
if not success then
	io.write(err)
end
