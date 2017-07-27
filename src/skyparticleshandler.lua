--- snowdrift/src/skyparticleshandler.lua
-- File to handle the particules emitted by the sky.


-- Function
-- ========

--- Call the spawning of particules if there is data for particules.
-- @param player_data the metadata to spawn particules, use almost all index and the setter of the quota
-- @return the percent of particules that have been generated
function snowdrift.set_particules(player_data)
	local particle_data = snowdrift.particles_data[player_data.weather]
	if particle_data then
		return snowdrift.particulespawner(particle_data, player_data)
	end
	return 0
end


-- Function local -- TODO make that functions really local
-- ==============


--- Return a random position around ppos according the data of the particules.
-- @param particle_data the tables of data for particules
-- @param ppos set particules around that position
-- @return 
function snowdrift.particule_position(particle_data, player_data)
	local min_box = vector.add(player_data.ppos, particle_data.min_box)
	local random_vector = vector.apply(particle_data.random_vector, math.random)
	return vector.add(min_box, random_vector)
end


--- Spawn particules for the player around its position.
-- @param particle_data the data for particules
-- @param player_data the metadata to spawn particules
-- @return the percent of particules that have been generated
function snowdrift.particulespawner(particle_data, player_data)
		local outside_quota = 0
		for i_particule = 1, particle_data.base_number do
		
			local pos_particule = snowdrift.particule_position(particle_data, player_data)
			
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
						playername = player_data.player_name
					})
				outside_quota = outside_quota + 1 / particle_data.base_number
			end
		end
	snowdrift.set_quota(player_data, outside_quota)
end

