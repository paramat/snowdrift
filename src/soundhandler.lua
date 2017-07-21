--[[ snowdrift/src/soundhandler.lua
File to handle sound of the weather.
Version :
]]


-- Configuration
-- =============

 -- Sound volume
local RAINGAIN = 0.2
local SNOWGAIN = 0.3

local OUTSIDE_QUOTA = 0.3 -- minimum of emmited particles to play a sound
local handles = {}

-- Register
-- ========

-- Stop sound and remove player handle on leaveplayer

minetest.register_on_leaveplayer(function(player)
	local player_name = player:get_player_name()
	if handles[player_name] then
		minetest.sound_stop(handles[player_name])
		handles[player_name] = nil
	end
end)


-- Functions
-- =========

--  to play sound

--[[ snowdrift.set_sound_for_particles(quota, has_changed, weather, player)
Play (or stop) the sound according the weather if it's not already played.
quota : percent of particules that have been generated
has_changed : if the weather have changed
weather : the weather to play the according sound
player : the player to play the sound
]]
function snowdrift.set_sound_for_particles(quota, has_changed, weather, player)
	local player_name = player:get_player_name()
	if quota < OUTSIDE_QUOTA then
		snowdrift.stop_sound(player_name)
	elseif has_changed then
		snowdrift.stop_sound(player_name)
		if (weather == "rain") then -- need new sound
			snowdrift.set_sound_rain(player_name)
		elseif (weather == "snow") then
			snowdrift.set_sound_snow(player_name)
		end
	end
end


--[[ snowdrift.set_sound_snow(player_name)
Play the snow sound to the player called name.
]]
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


--[[ snowdrift.set_sound_rain(player_name)
Play the rain sound to the player called name.
]]
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


--  to stop sound

--[[ snowdrift.set_sound_for_particles(player_name)
Stop sound to the player called name.
]]
function snowdrift.stop_sound(player_name)
	if handles[player_name] then
		minetest.sound_stop(handles[player_name])
		handles[player_name] = nil
	end
end

