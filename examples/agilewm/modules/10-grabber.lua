-- Grabber module

local grabActive

grabber = function (f)
	local root = connection:window(screen.root)
	connection:grab_pointer(root, false, {"BUTTON_RELEASE", "BUTTON_MOTION", "POINTER_MOTION_HINT"}, true, true, root)
	grabActive = f
end

return function (evtype, evdata, evsent)
	if grabActive then
		if evtype == "button_release" then
			grabActive = nil
			connection:ungrab_pointer()
			return true
		elseif evtype == "motion_notify" then
			local root = connection:window(screen.root)
			connection:grab_pointer(root, false, {"BUTTON_RELEASE", "BUTTON_MOTION", "POINTER_MOTION_HINT"}, true, true, root)
			grabActive(evdata.root_x, evdata.root_y)
			return true
		end
	end
end
