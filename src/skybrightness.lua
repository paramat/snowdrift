--- snowdrift/src/skybrightness.lua
-- File to manage the modification of the brightness of sky.


--- Set the brightness of the sky of the player according to his weather.
-- @param player_data metadata of the player, get player_data.player and player_data.weather
function snowdrift.set_sky_brightness(player_data)
	local player = player_data.player
	-- Occasionally reset player sky
	if math.random() < 0.1 then
		if (player_data.weather == "clear") then
			-- Reset sky to normal
			player:set_sky({}, "regular", {})
		else
			-- Set overcast sky
			local sval
			local time = minetest.get_timeofday()
			if time >= 0.5 then
				time = 1 - time
			end
			-- Sky brightness transitions:
			-- First transition (24000 -) 4500, (1 -) 0.1875
			-- Last transition (24000 -) 5750, (1 -) 0.2396
			if time <= 0.1875 then
				sval = snowdrift.NISVAL
			elseif time >= 0.2396 then
				sval = snowdrift.DASVAL
			else
				sval = math.floor(snowdrift.NISVAL + ((time - 0.1875) / 0.0521) * snowdrift.difsval)
			end
			player:set_sky({r = sval, g = sval, b = sval + 16, a = 255}, "plain", {})
		end
	end
end

