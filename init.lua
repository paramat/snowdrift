-- Parameters

local PRECSPR = 11 -- Time scale for precipitation variation in minutes
local PRECOFF = 0.8 -- Precipitation noise threshold offset
local PROCHA = 0.2 -- Per player per globalstep processing chance
local FLAKES = 8 -- Snowflake density
local DROPS = 16 -- Rainfall density
local NISVAL = 39 -- Clouds RGB value at night
local DASVAL = 175 -- Clouds RGB value in daytime

local np_prec = {
	offset = 0,
	scale = 1,
	spread = {x = PRECSPR, y = PRECSPR, z = PRECSPR},
	seed = 813,
	octaves = 1,
	persist = 0,
	lacunarity = 2.0,
	--flags = ""
}

-- These 2 must match biome heat and humidity noise parameters for a world

local np_temp = {
	offset = 50,
	scale = 50,
	spread = {x = 1000, y = 1000, z = 1000},
	seed = 5349,
	octaves = 3,
	persist = 0.5,
	lacunarity = 2.0,
	--flags = ""
}

local np_humid = {
	offset = 50,
	scale = 50,
	spread = {x = 1000, y = 1000, z = 1000},
	seed = 842,
	octaves = 3,
	persist = 0.5,
	lacunarity = 2.0,
	--flags = ""
}


-- Stuff

local difsval = DASVAL - NISVAL


-- Initialise noise objects to nil

local nobj_temp = nil
local nobj_humid = nil
local nobj_prec = nil


-- Globalstep function

minetest.register_globalstep(function(dtime)
	for _, player in ipairs(minetest.get_connected_players()) do
		-- Randomise and spread processing load
		if math.random() > PROCHA then
			return
		end

		local ppos = player:getpos()
		local pposx = math.floor(ppos.x)
		local pposy = math.floor(ppos.y)
		local pposz = math.floor(ppos.z)

		local nobj_temp = nobj_temp or minetest.get_perlin(np_temp)
		local nobj_humid = nobj_humid or minetest.get_perlin(np_humid)
		local nobj_prec = nobj_prec or minetest.get_perlin(np_prec)

		local nval_temp = nobj_temp:get2d({x = pposx, y = pposz})
		local nval_humid = nobj_humid:get2d({x = pposx, y = pposz})
		local nval_prec = nobj_prec:get2d({x = os.clock() / 60, y = 0})

		-- Biome system: frozen biomes below heat 35,
		-- deserts below humidity 20
		local freeze = nval_temp < 35
		local precip = nval_prec > (nval_humid - 50) / 50 + PRECOFF

		-- Check if player is outside
		local outside = minetest.get_node_light(ppos, 0.5) == 15

		-- Occasionally reset player sky
		if math.random() < 0.05 then
			if precip then
				-- Set overcast sky
				local sval
				local time = minetest.get_timeofday()
				if time >= 0.5 then
					time = 1 - time
				end

				-- Sky brightness transitions:
				-- First transition (24000 -) 4500, (1 -) 0.1875
				-- Last transition (24000 -) 5750, (1 -) 0.2396
				if time <= 0.1875 then
					sval = NISVAL
				elseif time >= 0.2396 then
					sval = DASVAL
				else
					sval = math.floor(NISVAL + ((time - 0.1875) / 0.0521) * difsval)
				end

				player:set_sky({r = sval, g = sval, b = sval + 16, a = 255}, "plain", {})
			else
				-- Reset sky to normal
				player:set_sky({}, "regular", {})
			end
		end

		if precip and outside then
			-- Precipitation
			if freeze then
				-- Snowfall
				for flake = 1, FLAKES do
					minetest.add_particle({
						pos = {
							x = pposx - 32 + math.random(0, 63),
							y = pposy + 10 + math.random(0, 4),
							z = pposz - 26 + math.random(0, 63)
						},
						vel = {
							x = 0.0,
							y = -2.0,
							z = -1.0
						},
						acc = {x = 0, y = 0, z = 0},
						expirationtime = 12,
						size = 2.8,
						collisiondetection = false,
						vertical = false,
						texture = "snowdrift_snowflake" .. math.random(1, 4) .. ".png",
						playername = player:get_player_name()
					})
				end
			else
				-- Rainfall
				for flake = 1, DROPS do
					minetest.add_particle({
						pos = {
							x = pposx - 8 + math.random(0, 16),
							y = pposy + 6 + math.random(0, 4),
							z = pposz - 8 + math.random(0, 16)
						},
						vel = {
							x = 0.0,
							y = -8.0,
							z = 0.0
						},
						acc = {x = 0, y = 0, z = 0},
						expirationtime = 2,
						size = 2.8,
						collisiondetection = false,
						vertical = true,
						texture = "snowdrift_raindrop.png",
						playername = player:get_player_name()
					})
				end
			end
		end
	end
end)
