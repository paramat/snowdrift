-- Parameters

local YLIMIT = 1 -- Set to world's water level
					-- Particles are timed to disappear at this y
					-- Particles do not spawn when player's head is below this y
local PRECTIM = 5 -- Precipitation noise spread
					-- Time scale for precipitation variation, in minutes
local PRECTHR = 0.2 -- Precipitation noise threshold, -1 to 1:
					-- -1 = precipitation all the time
					-- 0 = precipitation half the time
					-- 1 = no precipitation
local FLAKLPOS = 32 -- Snowflake light-tested positions per cycle
					-- Maximum number of snowflakes spawned per 0.5s
local DROPLPOS = 64 -- Raindrop light-tested positions per cycle
					-- Maximum number of raindrops spawned per 0.5s
local DROPPPOS = 2 -- Raindrops per light-tested pos
local RAINGAIN = 0.2 -- Rain sound volume
local NISVAL = 39 -- Overcast sky RGB value at night (brightness)
local DASVAL = 159 -- Overcast sky RGB value in daytime (brightness)
local FLAKRAD = 16 -- Radius in which flakes are created
local DROPRAD = 16 -- Radius in which drops are created

local np_prec = {
	offset = 0,
	scale = 1,
	spread = {x = PRECTIM, y = PRECTIM, z = PRECTIM},
	seed = 813,
	octaves = 1,
	persist = 0,
	lacunarity = 2.0,
	flags = "defaults"
}

-- These 2 must match biome heat and humidity noise parameters for a world

local np_temp = {
	offset = 50,
	scale = 50,
	spread = {x = 1000, y = 1000, z = 1000},
	seed = 5349,
	octaves = 3,
	persist = 0.5,
	lacunarity = 2.0,
	flags = "defaults"
}

local np_humid = {
	offset = 50,
	scale = 50,
	spread = {x = 1000, y = 1000, z = 1000},
	seed = 842,
	octaves = 3,
	persist = 0.5,
	lacunarity = 2.0,
	flags = "defaults"
}

-- End parameters


-- Stuff

local difsval = DASVAL - NISVAL
local grad = 14 / 95
local yint = 1496 / 95


-- Initialise noise objects to nil

local nobj_temp = nil
local nobj_humid = nil
local nobj_prec = nil


-- Globalstep function

local handles = {}
local timer = 0

minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 0.5 then
		return
	end

	timer = 0

	for _, player in ipairs(minetest.get_connected_players()) do
		local player_name = player:get_player_name()
		-- Predict player position as slightly behind the cycle interval.
		-- Assume scheduling gets behind slighly (cycle time * 1.5).
		local ppos = vector.add(player:getpos(),
			vector.multiply(player:get_player_velocity(), 0.75))
		-- Point just above player head, for precipitation when swimming
		local pposy = math.floor(ppos.y) + 2
		if pposy >= YLIMIT - 2 then
			local pposx = math.floor(ppos.x)
			local pposz = math.floor(ppos.z)
			local ppos = {x = pposx, y = pposy, z = pposz}

			local nobj_temp = nobj_temp or minetest.get_perlin(np_temp)
			local nobj_humid = nobj_humid or minetest.get_perlin(np_humid)
			local nobj_prec = nobj_prec or minetest.get_perlin(np_prec)

			local nval_temp = nobj_temp:get2d({x = pposx, y = pposz})
			local nval_humid = nobj_humid:get2d({x = pposx, y = pposz})
			local nval_prec = nobj_prec:get2d({x = os.clock() / 60, y = 0})

			-- Biome system: Frozen biomes below heat 35,
			-- deserts below line 14 * t - 95 * h = -1496
			-- h = (14 * t + 1496) / 95
			-- h = 14/95 * t + 1496/95
			-- where 14/95 is gradient and 1496/95 is y intersection
			-- h - 14/95 t = 1496/95 y intersection
			-- so area above line is
			-- h - 14/95 t > 1496/95
			local freeze = nval_temp < 35
			local precip = nval_prec > PRECTHR and
				nval_humid - grad * nval_temp > yint

			-- Occasionally reset player sky
			if math.random() < 0.1 then
				if precip then
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
						sval = math.floor(NISVAL +
							((time - 0.1875) / 0.0521) * difsval)
					end
					-- Set sky to overcast bluish-grey
					player:set_sky({r = sval, g = sval, b = sval + 16, a = 255},
						"plain", {}, false)
				else
					-- Reset sky to normal
					player:set_sky({}, "regular", {}, true)
				end
			end

			if not precip or freeze then
				if handles[player_name] then
					-- Stop sound if playing
					minetest.sound_stop(handles[player_name])
					handles[player_name] = nil
				end
			end

			if precip then
				-- Precipitation
				if freeze then
					-- Snowfall
					for lpos = 1, FLAKLPOS do
						local lposx = pposx - FLAKRAD +
							math.random(0, FLAKRAD * 2)
						local lposz = pposz - FLAKRAD +
							math.random(0, FLAKRAD * 2)
						if minetest.get_node_light(
								{x = lposx, y = pposy + 10, z = lposz},
								0.5) == 15 then
							-- Any position above light-tested position is also
							-- light level 15.
							-- Spawn Y randomised to avoid particles falling
							-- in separated layers.
							-- Random range = speed * cycle time
							local spawny = pposy + 10 + math.random(0, 10) / 10
							local extime = math.min((spawny - YLIMIT) / 2, 10)

							minetest.add_particle({
								pos = {x = lposx, y = spawny, z = lposz},
								velocity = {x = 0, y = -2.0, z = 0},
								acceleration = {x = 0, y = 0, z = 0},
								expirationtime = extime,
								size = 2.8,
								collisiondetection = true,
								collision_removal = true,
								vertical = false,
								texture = "snowdrift_snowflake" ..
									math.random(1, 12) .. ".png",
								playername = player:get_player_name()
							})
						end
					end
				else
					-- Rainfall
					for lpos = 1, DROPLPOS do
						local lposx = pposx - DROPRAD +
							math.random(0, DROPRAD * 2)
						local lposz = pposz - DROPRAD +
							math.random(0, DROPRAD * 2)
						if minetest.get_node_light(
								{x = lposx, y = pposy + 10, z = lposz},
								0.5) == 15 then
							for drop = 1, DROPPPOS do
								local spawny = pposy + 10 + math.random(0, 60) / 10
								local extime = math.min((spawny - YLIMIT) / 12, 2)
								local spawnx = lposx - 0.4 + math.random(0, 8) / 10
								local spawnz = lposz - 0.4 + math.random(0, 8) / 10

								minetest.add_particle({
									pos = {x = spawnx, y = spawny, z = spawnz},
									velocity = {x = 0.0, y = -12.0, z = 0.0},
									acceleration = {x = 0, y = 0, z = 0},
									expirationtime = extime,
									size = 2.8,
									collisiondetection = true,
									collision_removal = true,
									vertical = true,
									texture = "snowdrift_raindrop.png",
									playername = player:get_player_name()
								})
							end
						end
					end

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
		elseif handles[player_name] then
			-- Stop sound when player goes under y limit
			minetest.sound_stop(handles[player_name])
			handles[player_name] = nil
		end
	end
end)


-- Stop sound and remove player handle on leaveplayer

minetest.register_on_leaveplayer(function(player)
	local player_name = player:get_player_name()
	if handles[player_name] then
		minetest.sound_stop(handles[player_name])
		handles[player_name] = nil
	end
end)
