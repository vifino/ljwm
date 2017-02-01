-- LJWM default bootscript
-- Loads files and what not.

local fname = arg[1]
if not fname then
	print("Usage: ljwm file.lua [args..]")
	os.exit(1)
end

ljwm = require("ljwm")

dofile(fname)