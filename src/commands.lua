--[[ snowdrift/src/commands.lua
File for privileges and chat commandes registration.
Version : release v0.7.0
]]


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
		snowdrift.set_weather(param)
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


