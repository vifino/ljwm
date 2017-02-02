--- Iterator for xcb_screen_iterator_t

local xcbr = require("xcb.raw")

return function(iter)
	return function()
		if iter.rem == 0 then return nil end
		local screen = iter.data
		xcbr.xcb_screen_next(iter)
		return screen
	end
end
