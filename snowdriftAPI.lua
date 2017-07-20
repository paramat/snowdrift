
-- Global variables
-- ===============

--[[
* force_weather is a boolean used to keep the same weather.
  It escapes calculations and apply the weather for every player without checking theirs environnements. 
  Not persistent when server is reboot.
]]

snowdrift.force_weather = false


-- Getter and setter
-- ================

function snowdrift.set_force_weather(param_bool)
	snowdrift.force_weather = param_bool
end


function snowdrift.get_force_weather()
	return snowdrift.force_weather
end


-- Fonction for commands
-- =====================

--[[ snowdrift.set_weather(param_weather)
Force the weather to be param_weather or unforce a forced weather.
param_weather : <rain|snow|clear|default>, default unforce a weather. ]]
function snowdrift.set_weather(param_weather)
	if (param_weather == "default") then
		snowdrift.force_weather = false
	else
		snowdrift.force_weather = true
		snowdrift.weather = param_weather
	end
end


--[[ snowdrift.chat_send_player_weather(name)
Send information about what weather is and if it's forced or not to the chat of the player name.
name : a name of a valid player. ]]
function snowdrift.chat_send_player_weather_cmd(name)
Local msg = "The weather is " .. -- TODO call fonction that calculate the weather for the player
	if snowdrift.force_weather then
		msg .. ".\nThe weather is forced."
	else
		msg .. " naturally."
	end
	minetest.chat_send_player(name, msg)
end

