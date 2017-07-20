

local RAINGAIN = 0.2 -- Rain sound volume

local handles = {}

-- In the loop


local outside_quota = 0

 -- in if precip loop
					if not handles[player_name] then
						-- Start sound if not playing
						local handle = minetest.sound_play(
							"snowdrift_rain",
							{
								to_player = player_name,
								gain = RAINGAIN,
								loop = true,
							}
						)
						if handle then
							handles[player_name] = handle
						end
					end
				end
			end
			if not precip or freeze or outside_quota < 0.3 then
				if handles[player_name] then
					-- Stop sound if playing
					minetest.sound_stop(handles[player_name])
					handles[player_name] = nil
				end
			end

		elseif handles[player_name] then
			-- Stop sound when player goes under y limit
			minetest.sound_stop(handles[player_name])
			handles[player_name] = nil



-- Stop sound and remove player handle on leaveplayer

minetest.register_on_leaveplayer(function(player)
	local player_name = player:get_player_name()
	if handles[player_name] then
		minetest.sound_stop(handles[player_name])
		handles[player_name] = nil
	end
end)
