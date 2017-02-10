local xcb = require("xcb.wrapper")
describe("xcb.wrappers can connect,", function()
	local conn = xcb.connect()

	describe("get the focussed window's wid", function()
		local wid = conn:get_input_focus():reply(conn).focus
		assert.is_truthy(wid)

		it("and list the children", function()
			local wind = conn:window(wid)
			assert.is_truthy(wind)
			print("Window:", wind)

			assert.is_equals(type(wind.children), "function")

			print("Children:")
			local children = wind:children()
			for n, wid in pairs(children) do
				assert.is_truthy(wid)
				print("        "..tostring(wid))
			end
		end)
	end)
end)
