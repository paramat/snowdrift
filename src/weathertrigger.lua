--[[ snowdrift/src/weathertrigger.lua
File of the trigger of the weather.
Version : release v0.7.0
]]

local previous_weather = {}


--[[ snowdrift.is_weather_changed(weather)
Function to detect change of weather.
Return true if the weather change
]]
function snowdrift.is_weather_changed(weather, player)
	local player_name = player:get_player_name()
	local has_changed
	if previous_weather[player_name] then
		has_changed = (previous_weather[player_name] ~= weather)
	else
		has_changed = true
	end
	previous_weather[player_name] = weather
	return has_changed
end


--[[ snowdrift.clean_previous_weather(player_name)
Clean when player leave.
]]
function snowdrift.clean_previous_weather(player_name)
	previous_weather[player_name] = nil
end

