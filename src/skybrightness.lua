--- snowdrift/src/skybrightness.lua
-- File to manage the modification of the brightness of sky.


-- Configuration
-- =============

local NISVAL = 39 -- Clouds RGB value at night
local DASVAL = 175 -- Clouds RGB value in daytime
local difsval = DASVAL - NISVAL


--- snowdrift.set_sky_brightness(weather, player)
-- Set the brightness of the sky of the given player, according to the given weather.
-- @param weather weather to set the the brightness of the sky
-- @param player player who must see the sky
function snowdrift.set_sky_brightness(weather, player)
	-- Occasionally reset player sky
	if math.random() < 0.1 then
		if (weather == "clear") then
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
				sval = NISVAL
			elseif time >= 0.2396 then
				sval = DASVAL
			else
				sval = math.floor(NISVAL + ((time - 0.1875) / 0.0521) * difsval)
			end
			player:set_sky({r = sval, g = sval, b = sval + 16, a = 255}, "plain", {})
		end
	end
end

