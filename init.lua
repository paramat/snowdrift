snowdrift = {}

dofile(minetest.get_modpath("snowdrift").."/calculation.lua")
dofile(minetest.get_modpath("snowdrift").."/soundhandler.lua")
dofile(minetest.get_modpath("snowdrift").."/snowdriftAPI.lua")
dofile(minetest.get_modpath("snowdrift").."/commands.lua")

-- Parameters

local GSCYCLE = 0.5 -- Globalstep cycle (seconds)


-- Globalstep function

local timer = 0

minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < GSCYCLE then
		return
	end

	timer = 0

	for _, player in ipairs(minetest.get_connected_players()) do
		local player_name = player:get_player_name()

		-- cut to calculation.lua (cut if pposy >= YLIMIT)

			if precip then
				-- Precipitation
				if freeze then
				else
		end
	end
end)


