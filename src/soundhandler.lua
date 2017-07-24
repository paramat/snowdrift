--- snowdrift/src/soundhandler.lua
-- File to handle sound of the weather.


-- Configuration
-- =============

 -- Sound volume
local RAINGAIN = 0.2
local SNOWGAIN = 0.3

local OUTSIDE_QUOTA = 0.3 -- minimum of emmited particles to play a sound

-- Variables

local handles = {}
local bool_previous_quota = false


-- Functions
-- =========


--- To detect if the quota change of side of limit.
-- @param quota the 
-- @return true if it changes
function snowdrift.is_bool_quota_changed(quota)
	local new_bool_qota = not (quota < OUTSIDE_QUOTA)
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
	if (snowdrift.is_bool_quota_changed(quota) or wheather_has_changed) then
		snowdrift.stop_sound(player_name)
		if bool_previous_quota then
			if (weather == "rain") then -- need new sound
				snowdrift.set_sound_rain(player_name)
			elseif (weather == "snow") then
				snowdrift.set_sound_snow(player_name)
			end
		end
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


-- Functions local
-- ===============


--- Play the snow sound to the player called name. Called by snowdrift.set_sound_for_particles(quota, wheather_has_changed, weather, player).
-- @param player the player to play the sound
function snowdrift.set_sound_snow(player_name)
	local new_handle = minetest.sound_play(
		"cobratronik_wind_artic_cold",
		{
			to_player = player_name,
			gain = SNOWGAIN,
			loop = true,
		})
	if new_handle then
		handles[player_name] = new_handle
	end
end


--- Play the rain sound to the player called name. Called by snowdrift.set_sound_for_particles(quota, wheather_has_changed, weather, player).
-- @param player the player to play the sound
function snowdrift.set_sound_rain(player_name)
	local new_handle = minetest.sound_play(
		"snowdrift_rain",
		{
			to_player = player_name,
			gain = RAINGAIN,
			loop = true,
		})
	if new_handle then
		handles[player_name] = new_handle
	end
end

