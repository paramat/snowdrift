--- snowdrift/src/init.lua
-- Main file of the mod snowdrift.
-- Include other file and launch the main loop.


-- Mod name
snowdrift = {}


-- Global variables
-- ===============

--- force_weather is a a string representing a weather or the string "default".
-- "default" let the calculations decide of the wheather.
-- "rain", "snow" or "clear" escape calculations and are applyed for every player without checking theirs environnements.
-- Not persistent when server is reboot.
snowdrift.force_weather = "default"


-- Including other files
-- =====================


dofile(minetest.get_modpath("snowdrift").."/lib/utils.lua")
dofile(minetest.get_modpath("snowdrift").."/futuresettings.lua")
dofile(minetest.get_modpath("snowdrift").."/src/definitions.lua")

dofile(minetest.get_modpath("snowdrift").."/src/weathertrigger.lua")
dofile(minetest.get_modpath("snowdrift").."/src/skyparticleshandler.lua")
dofile(minetest.get_modpath("snowdrift").."/src/skybrightness.lua")
dofile(minetest.get_modpath("snowdrift").."/src/calculation.lua")
dofile(minetest.get_modpath("snowdrift").."/src/soundhandler.lua")

dofile(minetest.get_modpath("snowdrift").."/snowdriftAPI.lua")
dofile(minetest.get_modpath("snowdrift").."/src/commands.lua")


-- Register
-- ========

-- Cleanning on leaveplayer
minetest.register_on_leaveplayer(function(player)
	local player_name = player:get_player_name()
	snowdrift.stop_sound(player_name)
	snowdrift.clean_previous_weather(player_name)
end)


-- Globalstep function
-- ===================

local timer = 0

minetest.register_globalstep(function(dtime)
 -- Timer
	timer = timer + dtime
	if timer < snowdrift.GSCYCLE then
		return
	end
	timer = 0
	
	-- Main loop
	for _, player in ipairs(minetest.get_connected_players()) do
		local ppos = snowdrift.ppos_for_player(player)
		local weather = snowdrift.weather_for_ppos(ppos)
		local has_changed = snowdrift.is_weather_changed(weather, player)
		local outside_quota
		snowdrift.set_sky_brightness(weather, player)
		outside_quota = snowdrift.set_particules(weather, player, ppos)
		snowdrift.set_sound_for_particles(outside_quota, has_changed, weather, player)
	end
end)



