--[[ snowdrift/src/weathertrigger.lua
File of the trigger of the weather.
Version : release v0.7.0
]]

local previous_weather


--[[ snowdrift.is_weather_changed(weather)
Function to detect change of weather.
Return true if the weather change
]]
function snowdrift.is_weather_changed(weather)
	local has_changed = (previous_weather ~= weather)
	previous_weather = weather
	return has_changed
end
