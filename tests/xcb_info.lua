local ffi = require("ffi")

local xcb = require("xcb.wrapper")

-- Open the connection to the X server. Use the DISPLAY environment variable */
local conn = xcb.connect()
local setup = conn:get_setup()

local no = 0
for screen in setup:setup_roots() do
	print("Screen: ", screen, screen.root, no);

	-- report
	printf ("\n");
	printf ("Information of screen %d:\n", no);       -- "PRIu32"
	printf ("  width.........: %d\n", screen.width_in_pixels);  -- "PRIu16"
	printf ("  height........: %d\n", screen.height_in_pixels); -- "PRIu16"

	printf ("  white pixel...: 0x%x\n", screen.white_pixel);      -- "PRIu32"
	printf ("  black pixel...: 0x%x\n", screen.black_pixel);      -- "PRIu32"
	printf ("\n");
	no = no + 1
end
