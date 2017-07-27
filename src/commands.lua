--- snowdrift/src/commands.lua
-- File for privileges and chat commandes registration.


-- Privilege weather
minetest.register_privilege("weather", {
	description = "Force the weather",
	give_to_singleplayer = false
})


-- Commande to force weather
minetest.register_chatcommand("setweather", {
	params = "<rain|snow|clear|default>",
	description = "Force the weather to rain, snow or clear, without limit of time. Use default to let it do.",
	privs = {weather = true},
	func = function(name, param)
		snowdrift.set_force_weather(param)
	end
})

-- Commande to receive informations, in the chat, about weather
minetest.register_chatcommand("weather", {
	params = "",
	description = "Send information about what weather is and if it's forced or natural",
	func = function(name, param)
		snowdrift.chat_send_player_weather(name)
	end
})



-- Function
-- ========

--- Send information about what weather is and if it's forced or not to the chat of the player called name.
-- @param name a name of a valid player
function snowdrift.chat_send_player_weather(player_name)
	local msg = "The weather is "
	msg = (msg .. snowdrift.players_data[player_name].weather)
	if (snowdrift.force_weather ~="default") then
		msg = (msg .. ".\nThe weather is forced.")
	else
		msg = (msg .. " naturally.")
	end
	minetest.chat_send_player(player_name, msg)
end

