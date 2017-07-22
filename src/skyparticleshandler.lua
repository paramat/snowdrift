--[[ snowdrift/src/skyparticleshandler.lua
File to handle the particules emitted by the sky.
Version : release v0.7.0
]]


-- Configuration
-- =============

local COLLIDE = true -- Whether particles collide with nodes


-- Rain
local DROPS = 64 -- Raindrops per cycle
local RAINBOX = {x = -8, y = 8, z = -8}
local RAINVELOCITY = {x = 0.0, y = -10.0, z = 0.0}
local RAINACCELERATION = {x = 0, y = 0, z = 0}


-- Snow
local FLAKES = 16 -- Snowflakes per cycle
local SNOWBOX = {x = -24, y = 8, z = -20}
local SNOWVELOCITY = {x = 0.0, y = -2.0, z = -1.0}
local SNOWACCELERATION = {x = 0, y = 0, z = 0}



-- Function
-- ========

--[[ snowdrift.set_particules(weather, player, ppos)
Spawn particules for the given player around its corresponding position ppos and according to the given weather.
Return the percent of particules that have been generated.
]]
function snowdrift.set_particules(weather, player, ppos)
	local player_name = player:get_player_name()
	if (weather == "rain") then
		return snowdrift.set_particules_rain(player, ppos)
	elseif (weather == "snow") then
		return snowdrift.set_particules_snow(player, ppos)
	end
	return 0
end


--[[ snowdrift.set_particules_snow(player, ppos)
Spawn snow particules for the given player around its corresponding position ppos.
Return the percent of particules that have been generated.
]]
function snowdrift.set_particules_snow(player, ppos)
	local outside_quota = 0
	for flake = 1, FLAKES do
		local box = vector.add(ppos, SNOWBOX)
		local random_vector = { 
			x = math.random(0, 47),
			y = math.random(0, 1),
			z = math.random(0, 47)
		}
		local pos = vector.add(box, random_vector)
		if minetest.get_node_light(pos, 0.5) == 15 then
			minetest.add_particle({
				pos = pos,
				velocity = SNOWVELOCITY,
				acceleration = SNOWACCELERATION,
				expirationtime = 8.5,
				size = 2.8,
				collisiondetection = COLLIDE,
				collision_removal = true,
				vertical = false,
				texture = "snowdrift_snowflake" .. math.random(1, 4) .. ".png",
				playername = player:get_player_name()
			})
			outside_quota = outside_quota + 1 / FLAKES
		end
	end
	return outside_quota
end


--[[ snowdrift.set_particules_rain(player, ppos)
Spawn rain particules for the given player around its corresponding position ppos.
Return the percent of particules that have been generated.
]]
function snowdrift.set_particules_rain(player, ppos)
	local outside_quota = 0
	for drop = 1, DROPS do
		local box = vector.add(ppos, RAINBOX)
		local random_vector = { 
			x = math.random(0, 16),
			y =  math.random(0, 5),
			z =  math.random(0, 16)
		}
		local pos = vector.add(box, random_vector)
		if minetest.get_node_light(pos, 0.5) == 15 then
			minetest.add_particle({
				pos = pos,
				velocity = RAINVELOCITY,
				acceleration = RAINACCELERATION,
				expirationtime = 2.1,
				size = 2.8,
				collisiondetection = COLLIDE,
				collision_removal = true,
				vertical = true,
				texture = "snowdrift_raindrop.png",
				playername = player:get_player_name()
			})
			outside_quota = outside_quota + 1 / DROPS
		end
	end
	return outside_quota
end

