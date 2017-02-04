local ffi = require("ffi")
local xcb = require("xcb.wrapper")

describe("xcb.wrappers", function()
	describe("can connect to the X server", function()
		local conn = xcb.connect()
		describe("and then disconnect", function()
			conn:disconnect()
		end)
	end)

	describe("can get the setup_roots", function()
		local conn = xcb.connect()
		local setup = conn:get_setup()
		describe("and iterate over them", function()
			local no = 0
			for screen in setup:setup_roots() do
				assert.is_truthy(screen)
				assert.is_not_equal(screen.root, 0)
				print("Screen: ", screen, screen.root, no)

				-- report
				printf("\n");
				printf("Information of screen %d:\n", no)
				printf("  width.........: %d\n", screen.width_in_pixels)
				printf("  height........: %d\n", screen.height_in_pixels)

				printf("  white pixel...: 0x%x\n", screen.white_pixel)
				printf("  black pixel...: 0x%x\n", screen.black_pixel)
				printf("\n");
				no = no + 1
			end
		end)
	end)
end)
