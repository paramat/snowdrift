--- snowdrift/src/weathertrigger.lua
-- File of the trigger of the weather.


local previous_weather = {}


--- Function to detect change of weather.
-- @param weather new weather
-- @param player concerned player
-- @return true if the weather change
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


--- Clean when player leave.
-- @param player_name name of concerned player
function snowdrift.clean_previous_weather(player_name)
	previous_weather[player_name] = nil
end

