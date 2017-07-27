--- snowdrift/src/calculation.lua
-- File of functions about calculations of snowdrift.


-- Stuff
local grad = 14 / 95
local yint = 1496 / 95


-- Initialization
-- ==============

-- Initialise noise objects to nil
local nobj_temp = nil
local nobj_humid = nil
local nobj_prec = nil


-- Function to calculate the weather
-- =================================

--- Calculate the weather for the given position.
-- @param player_data the metadata of the player, get player_data.ppos and set_weather(player_data, new_weather)
function snowdrift.calcul_weather(player_data)
	if (snowdrift.force_weather ~="default") then -- Avoid calculations
		snowdrift.set_weather(player_data, snowdrift.force_weather)
		return
	end
	local ppos = player_data.ppos
	if not (ppos.y >= snowdrift.YLIMIT) then
		snowdrift.set_weather(player_data, "clear") -- TODO issue : change the sky color
	else
		local nobj_temp = nobj_temp or minetest.get_perlin(snowdrift.np_temp)
		local nobj_humid = nobj_humid or minetest.get_perlin(snowdrift.np_humid)
		local nobj_prec = nobj_prec or minetest.get_perlin(snowdrift.np_prec)

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
		local precip = nval_prec < (nval_humid - 50) / 50 + snowdrift.PRECOFF and
					nval_humid - grad * nval_temp > yint
		
		if precip then
			if freeze then
				snowdrift.set_weather(player_data, "snow")
			else
				snowdrift.set_weather(player_data, "rain")
			end
		else
			snowdrift.set_weather(player_data, "clear")
		end
	end
end

