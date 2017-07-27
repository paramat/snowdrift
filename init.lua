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

dofile(minetest.get_modpath("snowdrift").."/src/playermetada.lua")
dofile(minetest.get_modpath("snowdrift").."/src/skyparticleshandler.lua")
dofile(minetest.get_modpath("snowdrift").."/src/skybrightness.lua")
dofile(minetest.get_modpath("snowdrift").."/src/calculation.lua")
dofile(minetest.get_modpath("snowdrift").."/src/soundhandler.lua")

dofile(minetest.get_modpath("snowdrift").."/snowdriftAPI.lua")
dofile(minetest.get_modpath("snowdrift").."/src/commands.lua")


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
		local player_data = snowdrift.initialize_player_data(player)
		
		player_data.ppos = snowdrift.ppos_for_player(player)
		player_data.has_changed = false
		
		snowdrift.calcul_weather(player_data)
		snowdrift.set_sky_brightness(player_data) -- TODO put in listener
		snowdrift.set_particules(player_data)
		snowdrift.set_sound_for_particles(player_data) -- TODO put in listener
	end
end)



