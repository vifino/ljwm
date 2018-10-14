-- New terminal module
return function(evtype, evdata, evsent)
	if evtype == "init" then
		evdata.root_configure.event_mask = bit.bor(evdata.root_configure.event_mask, xcbe.event_mask.BUTTON_PRESS)
	elseif evtype == "button_press" then
		if evdata.event == screen.root then
			if evdata.detail == 1 then
				os.execute("xterm &")
			end
		end
	end
end
