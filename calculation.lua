

-- Parameters

local YLIMIT = 1 -- Set to world's water level or level of lowest open area,
				-- calculations are disabled below this y.
local PRECSPR = 6 -- Time scale for precipitation variation in minutes
local PRECOFF = -0.4 -- Precipitation offset, higher = rains more often
local NISVAL = 39 -- Clouds RGB value at night
local DASVAL = 175 -- Clouds RGB value in daytime

local np_prec = {
	offset = 0,
	scale = 1,
	spread = {x = PRECSPR, y = PRECSPR, z = PRECSPR},
	seed = 813,
	octaves = 1,
	persist = 0,
	lacunarity = 2.0
}

-- These 2 must match biome heat and humidity noise parameters for a world

local np_temp = {
	offset = 50,
	scale = 50,
	spread = {x = 1000, y = 1000, z = 1000},
	seed = 5349,
	octaves = 3,
	persist = 0.5,
	lacunarity = 2.0
}

local np_humid = {
	offset = 50,
	scale = 50,
	spread = {x = 1000, y = 1000, z = 1000},
	seed = 842,
	octaves = 3,
	persist = 0.5,
	lacunarity = 2.0
}


-- Stuff

local difsval = DASVAL - NISVAL
local grad = 14 / 95
local yint = 1496 / 95


-- Initialise noise objects to nil

local nobj_temp = nil
local nobj_humid = nil
local nobj_prec = nil




-- in the loop

		local ppos = player:getpos()
		local pposy = math.floor(ppos.y) + 2 -- Precipitation when swimming
		if pposy >= YLIMIT then
			local pposx = math.floor(ppos.x)
			local pposz = math.floor(ppos.z)
			local ppos = {x = pposx, y = pposy, z = pposz}

			local nobj_temp = nobj_temp or minetest.get_perlin(np_temp)
			local nobj_humid = nobj_humid or minetest.get_perlin(np_humid)
			local nobj_prec = nobj_prec or minetest.get_perlin(np_prec)

			local nval_temp = nobj_temp:get2d({x = pposx, y = pposz})
			local nval_humid = nobj_humid:get2d({x = pposx, y = pposz})
			local nval_prec = nobj_prec:get2d({x = os.clock() / 60, y = 0})

			-- Biome system: Frozen biomes below heat 35,
			-- deserts below line 14 * t - 95 * h = -1496
			-- h = (14 * t + 1496) / 95
			-- h = 14/95 * t + 1496/95
			-- where 14/95 is gradient and 1496/95 is y intersection
			-- h - 14/95 t = 1496/95 y intersection
			-- so area above line is
			-- h - 14/95 t > 1496/95
			
			local freeze
				if (weather == "snow") then
					freeze = true
				else
					freeze = nval_temp < 35
				end
			
			local precip
				if (weather == "default") then
					precip = nval_prec < (nval_humid - 50) / 50 + PRECOFF and
					nval_humid - grad * nval_temp > yint
				elseif (weather == "clear") then -- To force the weather with commands
					precip = false
				else precip = true
				end

			-- Occasionally reset player sky
			if math.random() < 0.1 then
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

