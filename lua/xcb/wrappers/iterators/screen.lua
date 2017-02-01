--- Iterator for xcb_screen_iterator_t

local xcbr = require("xcb.raw")

return function(iter)
	return function()
		if iter.rem == 0 then return nil end
		xcbr.xcb_screen_next(iter)
		return iter.data
	end
end
