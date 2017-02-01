--- Iterator for xcb_screen_iterator_t

local xcbr = require("xcb.raw")

return function(iter)
	local none_remaining = false
	return function()
		if none_remaining then return nil end
		local data = iter.data
		if iter.rem == 0 then
			none_remaining = true
		else
			xcbr.xcb_screen_next(iter)
		end
		return data
	end
end
