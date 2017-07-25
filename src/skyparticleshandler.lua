--- snowdrift/src/skyparticleshandler.lua
-- File to handle the particules emitted by the sky.


-- Function
-- ========

--- Spawn particules for the given player around its corresponding position ppos and according to the given weather.
-- @param weather create particules of that weather
-- @param player the player who see particules
-- @param ppos set particules around that position
-- @return the percent of particules that have been generated
function snowdrift.set_particules(weather, player, ppos)
	local player_name = player:get_player_name()
	local particle_data = snowdrift.particles_data[weather]
	if particle_data then
		return snowdrift.particulespawner(particle_data, player_name, ppos)
	end
	return 0
end


-- Function local
-- ==============


--- Return a random position around ppos according the data of the particules.
-- @param particle_data the tables of data for particules
-- @param ppos set particules around that position
-- @return 
function snowdrift.particule_position(ppos, particle_data)
	local min_box = vector.add(ppos, particle_data.min_box)
	local random_vector = vector.apply(particle_data.random_vector, math.random)
	return vector.add(min_box, random_vector)
end


--- Spawn particules for the given player around its position ppos.
-- @param particle_data the tables of data for particules
-- @param player the player who see particules
-- @param ppos set particules around that position
-- @return the percent of particules that have been generated
function snowdrift.particulespawner(particle_data, player_name, ppos)
		local outside_quota = 0
		for i_particule = 1, particle_data.base_number do
			local pos_particule = snowdrift.particule_position(ppos, particle_data)
			if snowdrift.is_outside(pos_particule) then
				local random_index = math.random(1, table.getn(particle_data.texture))
				minetest.add_particle(
					{
						pos = pos_particule,
						velocity = particle_data.base_velocity,
						acceleration = particle_data.base_acceleration,
						expirationtime = particle_data.expirationtime,
						size = particle_data.size,
						collisiondetection = snowdrift.COLLIDE,
						collision_removal = true,
						vertical = false,
						texture =  particle_data.texture[random_index],
						playername = player_name
					})
				outside_quota = outside_quota + 1 / particle_data.base_number
			end
		end
	return outside_quota
end

