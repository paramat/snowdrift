--- snowdrift/src/snowdriftAPI.lua
-- File defining the API of the mod snowdrift


-- Global variables
-- ===============

--- force_weather is a a string representing a weather or the string "default".
-- "default" let the calculations decide of the wheather.
-- "rain", "snow" or "clear" escape calculations and are applyed for every player without checking theirs environnements.
-- Not persistent when server is reboot.
snowdrift.force_weather = "default"


-- Getter and setter
-- =================


function snowdrift.get_force_weather()
	return snowdrift.force_weather
end


--- Force the weather to be weather or unforce a forced weather.
-- @param weather <rain|snow|clear|default>, default unforce a weather
function snowdrift.set_weather(weather)
	snowdrift.force_weather = weather
end


-- Communication
-- =============

--- Send information about what weather is and if it's forced or not to the chat of the player called name.
-- @param name a name of a valid player
function snowdrift.chat_send_player_weather(name)
	local weather = snowdrift.weather_for_player(minetest.get_player_by_name(name))
	local msg = "The weather is "
	msg = (msg .. weather)
	if (snowdrift.force_weather ~="default") then
		msg = (msg .. ".\nThe weather is forced.")
	else
		msg = (msg .. " naturally.")
	end
	minetest.chat_send_player(name, msg)
end

