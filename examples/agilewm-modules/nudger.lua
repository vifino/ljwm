-- A simple testing module which moves mapped windows.
-- Just because.
-- And also prints some debugging messages.
print("Loaded 'nudger' test module, if not testing, do not use.")
return function(evtype, evdata, evsent)
	print("Nudger received", evtype)
	if evtype == "map_request" then
		local cw = connection:window(evdata.window)
		cw:configure({
			x = 64,
			y = 64
		})
	end
	return false
end
