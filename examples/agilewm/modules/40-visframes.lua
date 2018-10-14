-- Frame visuals

local precreated = {}
local createdframes = {}
local framegc = {}
-- margin up after addition of titleH. Removed after the creation happens or fails.
local wndu = {}
-- Y of beginning of title.
local frau = {}
local titleH = 20

return function(evtype, evdata, evsent)
	if evtype == "framer.precreate" then
		precreated[evdata.window] = true
		evdata.event_mask = bit.bor(evdata.event_mask, xcbe.event_mask.EXPOSURE)
		evdata.back_pixel = 0x303030
		evdata.margin.u = evdata.margin.u + titleH
		wndu[evdata.window] = evdata.margin.u
	elseif evtype == "framer.precreate.cancel" then
		precreated[evdata.window] = nil
		wndu[evdata.window] = nil
	elseif evtype == "framer.create" then
		frau[evdata.frame] = evdata.margin.u - wndu[evdata.window]
		wndu[evdata.window] = nil
		local gc = connection:gc(connection:generate_id())
		framegc[evdata.frame] = gc
		gc:create(evdata.frame, {})
		if precreated[evdata.window] then
			createdframes[evdata.frame] = evdata.window
		end
		precreated[evdata.window] = nil
	elseif evtype == "framer.destroy" then
		framegc[evdata.frame]:free()
		framegc[evdata.frame] = nil
		frau[evdata.window] = nil
		createdframes[evdata.frame] = nil
	elseif evtype == "expose" then
		local gc = framegc[evdata.window]
		local wndid = createdframes[evdata.window]
		if gc then
			local frame = connection:window(evdata.window)
			local geom = frame:get_geometry()
			local ffi = require("ffi")
			local xcbr = require("xcb.raw")
			--local repl = xcbr.xcb_get_property(connection, 0, createdframes[evdata.window], xcbe.atom_enum.WM_NAME, xcbe.atom_enum.STRING, 0, 0)
			--local reply = xcbr.xcb_get_property_reply(connection, repl, nil)
			--local l = xcbr.xcb_get_property_value_length(reply)
			--local p = xcbr.xcb_get_property_value(reply)
			gc:change({foreground = 0x303030})
			gc:poly_fill_rectangle(frame, {{0, 0, geom.width, geom.height}})
			gc:change({foreground = 0x181818})
			gc:poly_fill_rectangle(frame, {{0, frau[evdata.window], geom.width, titleH}})
			gc:change({foreground = 0x202020})
			gc:poly_fill_rectangle(frame, {{4, frau[evdata.window], geom.width - 8, titleH}})
			gc:change({foreground = 0xFFFFFF})
			gc:image_text_8(frame, 8, titleH - math.floor(titleH / 4), "Window " .. string.format("0x08%x", wndid))
			--ffi.string(p, l))
		end
	end
end
