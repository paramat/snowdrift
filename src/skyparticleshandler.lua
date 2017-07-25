--- snowdrift/src/skyparticleshandler.lua
-- File to handle the particules emitted by the sky.


-- Function
-- ========

--- Spawn particules for the given player around its corresponding position ppos and according to the given weather.
-- @param weather create particules of that weather
-- @param player the player who see particules
-- @param ppos set particules around that position
-- @return the percent of particules that have been generated.
function snowdrift.set_particules(weather, player, ppos)
	local player_name = player:get_player_name()
	if (weather == "rain") then
		return snowdrift.set_particules_rain(player, ppos)
	elseif (weather == "snow") then
		return snowdrift.set_particules_snow(player, ppos)
	end
	return 0
end


-- Function local
-- ==============

--- Spawn snow particules for the given player around its corresponding position ppos. Called by snowdrift.set_particules(weather, player, ppos).
-- @param player the player who see particules
-- @param ppos set particules around that position
-- @return the percent of particules that have been generated.
function snowdrift.set_particules_snow(player, ppos)
	local outside_quota = 0
	for flake = 1, snowdrift.FLAKES do
		local box = vector.add(ppos, snowdrift.SNOWBOX)
		local random_vector = { 
			x = math.random(0, 47),
			y = math.random(0, 1),
			z = math.random(0, 47)
		}
		local pos = vector.add(box, random_vector)
		if snowdrift.is_outside(pos) then
			minetest.add_particle({
				pos = pos,
				velocity = snowdrift.SNOWVELOCITY,
				acceleration = snowdrift.SNOWACCELERATION,
				expirationtime = 8.5,
				size = 2.8,
				collisiondetection = snowdrift.COLLIDE,
				collision_removal = true,
				vertical = false,
				texture = "snowdrift_snowflake" .. math.random(1, 4) .. ".png",
				playername = player:get_player_name()
			})
			outside_quota = outside_quota + 1 / snowdrift.FLAKES
		end
	end
	return outside_quota
end


--- Spawn rain particules for the given player around its corresponding position ppos. Called by snowdrift.set_particules(weather, player, ppos).
-- @param player the player who see particules
-- @param ppos set particules around that position
-- @return the percent of particules that have been generated.
function snowdrift.set_particules_rain(player, ppos)
	local outside_quota = 0
	for drop = 1, snowdrift.DROPS do
		local box = vector.add(ppos, snowdrift.RAINBOX)
		local random_vector = { 
			x = math.random(0, 16),
			y =  math.random(0, 5),
			z =  math.random(0, 16)
		}
		local pos = vector.add(box, random_vector)
		if snowdrift.is_outside(pos) then
			minetest.add_particle({
				pos = pos,
				velocity = snowdrift.RAINVELOCITY,
				acceleration = snowdrift.RAINACCELERATION,
				expirationtime = 2.1,
				size = 2.8,
				collisiondetection = snowdrift.COLLIDE,
				collision_removal = true,
				vertical = true,
				texture = "snowdrift_raindrop.png",
				playername = player:get_player_name()
			})
			outside_quota = outside_quota + 1 / snowdrift.DROPS
		end
	end
	return outside_quota
end

