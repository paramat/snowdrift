--- snowdrift/src/playermetada.lua
-- Metadata about the player


snowdrift.players_data = {} -- TODO may use plurial



function snowdrift.initialize_player_data(player)
	local player_name = player:get_player_name()
	if not snowdrift.players_data[player_name] then
		snowdrift.players_data[player_name] = {
			player = player,
			player_name = player_name,
			ppos = nil,
			weather = "clear",
			bool_quota = false,
			sound_handle = nil,
			has_changed = false, -- TODO must disapear with listener
			listener_weather = {},
			listener_bool_quota = {}
		}
	end
	return snowdrift.players_data[player_name]
end



function snowdrift.set_weather(player_name, new_weather)
	if (snowdrift.players_data[player_name].weather ~= new_weather) then
		snowdrift.players_data[player_name].has_changed = true
		-- TODO Call all listener
	end
	snowdrift.players_data[player_name].weather = new_weather
end


function snowdrift.set_quota(player_name, new_quota)
	local new_bool_quota = not (new_quota < snowdrift.OUTSIDE_QUOTA)
	if (snowdrift.players_data[player_name].bool_quota ~= new_bool_quota) then
		snowdrift.players_data[player_name].has_changed = true
		-- TODO Call all listener
	end
	snowdrift.players_data[player_name].bool_quota = new_bool_quota
end


-- Register
-- ========

-- Cleanning on leaveplayer
minetest.register_on_leaveplayer(function(player)
	local player_name = player:get_player_name()
		snowdrift.stop_sound(snowdrift.players_data[player_name])
		snowdrift.players_data[player_name] = nil
	end)



---------------------------------

-- Function to calculate position
-- ==============================

--- Calculate the position to use for the given player.
-- @param player player to calculate the position
-- @return a table with a value for x, y and z.
function snowdrift.ppos_for_player(player)
	local ppos = player:getpos()
	local pposy = math.floor(ppos.y) + 2 -- Precipitation when swimming
	local pposx = math.floor(ppos.x)
	local pposz = math.floor(ppos.z)
	return {x = pposx, y = pposy, z = pposz} -- round ?
end



-- Global variables -- TODO be a metadata for each player
-- ================

--- force_weather is a a string representing a weather or the string "default".
-- "default" let the calculations decide of the wheather.
-- "rain", "snow" or "clear" escape calculations and are applyed for every player without checking theirs environnements.
-- Not persistent when server is reboot.
snowdrift.force_weather = "default"


-- Getter and setter
-- =================


function snowdrift.get_force_weather()
	return snowdrift.force_weather
end


--- Force the weather to be weather or unforce a forced weather.
-- @param weather <rain|snow|clear|default>, default unforce a weather
function snowdrift.set_force_weather(weather)
	snowdrift.force_weather = weather
end


