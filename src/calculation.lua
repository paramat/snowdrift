--[[ snowdrift/src/calculation.lua
File of functions about calculations of snowdrift.
Version : release v0.7.0
]]


-- Configuration
-- =============

-- Set to world's water level or level of lowest open area,
-- calculations are disabled below this y.
local YLIMIT = 1 
				
-- Time scale for precipitation variation in minutes
local PRECSPR = 6

-- Precipitation offset, higher = rains more often
local PRECOFF = -0.4


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
local grad = 14 / 95
local yint = 1496 / 95


-- Initialization
-- ==============

-- Initialise noise objects to nil
local nobj_temp = nil
local nobj_humid = nil
local nobj_prec = nil


-- Function to calculate position
-- ==============================

--[[ snowdrift.ppos_for_player(player)
Calculate the position to use for the given player.
Return a table with a value for x, y and z.
]]
function snowdrift.ppos_for_player(player)
	local ppos = player:getpos()
	local pposy = math.floor(ppos.y) + 2 -- Precipitation when swimming
	local pposx = math.floor(ppos.x)
	local pposz = math.floor(ppos.z)
	return {x = pposx, y = pposy, z = pposz}
end


-- Function to calculate the weather
-- =================================

--[[ snowdrift.weather_for_ppos(ppos)
Calculate the weather for the given position.
Return a string representing the weather, or nil if the weather is forced.
String can be "rain", "snow" or "clear".
]]
function snowdrift.weather_for_ppos(ppos)
	if (snowdrift.force_weather ~="default") then -- Avoid calculations
		return snowdrift.force_weather
	end
	if not (ppos.y >= YLIMIT) then
		return "clear"
	else
		local nobj_temp = nobj_temp or minetest.get_perlin(np_temp)
		local nobj_humid = nobj_humid or minetest.get_perlin(np_humid)
		local nobj_prec = nobj_prec or minetest.get_perlin(np_prec)

		local nval_temp = nobj_temp:get2d({x = ppos.x, y = ppos.z})
		local nval_humid = nobj_humid:get2d({x = ppos.x, y = ppos.z})
		local nval_prec = nobj_prec:get2d({x = os.clock() / 60, y = 0})

--[[ Biome system: Frozen biomes below heat 35,
deserts below line 14 * t - 95 * h = -1496
h = (14 * t + 1496) / 95
h = 14/95 * t + 1496/95
where 14/95 is gradient and 1496/95 is y intersection
h - 14/95 t = 1496/95 y intersection
so area above line is
 h - 14/95 t > 1496/95 ]]
			
		local freeze = nval_temp < 35
		local precip = nval_prec < (nval_humid - 50) / 50 + PRECOFF and
					nval_humid - grad * nval_temp > yint
		
		local weather
		if precip then
			if freeze then
				weather = "snow"
			else
				weather = "rain"
			end
		else
			weather = "clear"
		end
		return weather
	end
end

--[[ snowdrift.weather_for_player(player)
Alias of snowdrift.weather_for_ppos(ppos) to use directly with player.
]]
function snowdrift.weather_for_player(player)
	local ppos = snowdrift.ppos_for_player(player)
	return snowdrift.weather_for_ppos(ppos)
end


