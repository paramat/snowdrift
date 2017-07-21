--[[ snowdrift/src/init.lua
Main file of the mod snowdrift.
Include other file and launch the main loop.
Version :
]]

-- Mod name
snowdrift = {}

-- Including other files
-- =====================


dofile(minetest.get_modpath("snowdrift").."/lib/utils.lua")
dofile(minetest.get_modpath("snowdrift").."/src/weathertrigger.lua")
dofile(minetest.get_modpath("snowdrift").."/src/skyparticleshandler.lua")
dofile(minetest.get_modpath("snowdrift").."/src/skybrightness.lua")
dofile(minetest.get_modpath("snowdrift").."/src/calculation.lua")
dofile(minetest.get_modpath("snowdrift").."/src/soundhandler.lua")
dofile(minetest.get_modpath("snowdrift").."/snowdriftAPI.lua")
dofile(minetest.get_modpath("snowdrift").."/src/commands.lua")


-- Configuration
-- =============

local GSCYCLE = 0.5 -- Globalstep cycle (seconds)


-- Globalstep function
-- ===================

local timer = 0

minetest.register_globalstep(function(dtime)
 -- Timer
	timer = timer + dtime
	if timer < GSCYCLE then
		return
	end
	timer = 0
	
	-- Main loop
	for _, player in ipairs(minetest.get_connected_players()) do
		local ppos = snowdrift.ppos_for_player(player)
		local weather = snowdrift.weather_for_ppos(ppos)
		local has_changed = snowdrift.is_weather_changed(weather)
		local outside_quota
		snowdrift.set_sky_brightness(weather, player)
		outside_quota = snowdrift.set_particules(weather, player, ppos)
		snowdrift.set_sound_for_particles(outside_quota, has_changed, weather, player)
	end
end)


