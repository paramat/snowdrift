
-- Privilege weather
minetest.register_privilege("weather", {
	description = "Force the weather",
	give_to_singleplayer = true
})


-- Commande to force weather
minetest.register_chatcommand("setweather", {
	params = "<rain|snow|clear|default>",
	description = "Force the weather to rain, snow or clear, without limit of time. Use default to let it do.",
	privs = {weather = true},
	func = function(name, param)
		snowdrift.set_weather_cmd(param)
	end
})

-- Commande to receive in the chat informations about weather
minetest.register_chatcommand("weather", {
	params = "",
	description = "Send information about what weather is and if it's forced or natural",
	func = function(name, param)
		snowdrift.chat_send_player_weather(name)
	end
})


