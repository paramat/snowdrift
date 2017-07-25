--- snowdrift/src/soundhandler.lua
-- File to handle sound of the weather.


-- Variables

local handles = {}
local bool_previous_quota = false


-- Functions
-- =========


--- To detect if the quota change of side of limit.
-- @param quota the 
-- @return true if it changes
function snowdrift.is_bool_quota_changed(quota)
	local new_bool_qota = not (quota < snowdrift.OUTSIDE_QUOTA)
	local has_changed = (bool_previous_quota ~= new_bool_qota)
	bool_previous_quota = new_bool_qota
	return has_changed
end


--- Play (or stop) the sound according the weather if it's not already played.
-- @param quota percent of particules that have been generated
-- @param has_changed if the weather have changed
-- @param weather the weather to play the according sound
-- @param player the player to play the sound
function snowdrift.set_sound_for_particles(quota, wheather_has_changed, weather, player)
	local player_name = player:get_player_name()
	local new_handle
	if (snowdrift.is_bool_quota_changed(quota) or wheather_has_changed) then
		local sound_data = snowdrift.sounds_data[weather]
		snowdrift.stop_sound(player_name)
		if sound_data then
			new_handle = minetest.sound_play(
			sound_data.song,
			{
				to_player = player_name,
				gain = sound_data.gain,
				loop = true,
			})
		end
	end
	if new_handle then
		handles[player_name] = new_handle
	end
end


--- Stop sound to the player called name.
-- @param player the player to stop the sound
function snowdrift.stop_sound(player_name)
	if handles[player_name] then
		minetest.sound_stop(handles[player_name])
		handles[player_name] = nil
	end
end

