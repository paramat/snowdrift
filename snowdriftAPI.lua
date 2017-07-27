--- snowdrift/src/snowdriftAPI.lua
-- File defining the API of the mod snowdrift


-- Getter and setter
-- =================


function snowdrift.get_force_weather()
	return snowdrift.force_weather
end


--- Force the weather to be weather or unforce a forced weather.
-- @param weather <rain|snow|clear|default>, default unforce a weather
function snowdrift.set_force_weather(weather)
	snowdrift.force_weather = weather
end


-- Communication
-- =============

--- Send information about what weather is and if it's forced or not to the chat of the player called name.
-- @param name a name of a valid player
function snowdrift.chat_send_player_weather(player_name)
	local msg = "The weather is "
	msg = (msg .. snowdrift.player_data[player_name].weather)
	if (snowdrift.force_weather ~="default") then
		msg = (msg .. ".\nThe weather is forced.")
	else
		msg = (msg .. " naturally.")
	end
	minetest.chat_send_player(player_name, msg)
end

