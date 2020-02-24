-- Parameters

local YWATER = 1 -- Normally set this to world's water level
				-- Particles are timed to disappear at this y
				-- Particles are not spawned for players below this y
				-- Rain sound is not played for players below this y
local YMIN = -48 -- Normally set this to deepest ocean
local YMAX = 120 -- Normally set this to cloud level
				-- Weather does not occur for players outside this y range
local PRECTIM = 300 -- Precipitation noise 'spread'
				-- Time scale for precipitation variation, in seconds
local PRECTHR = 0.2 -- Precipitation noise threshold, -1 to 1:
				-- -1 = precipitation all the time
				-- 0 = precipitation half the time
				-- 1 = no precipitation
local FLAKLPOS = 32 -- Snowflake light-tested positions per 0.5s cycle
				-- Maximum number of snowflakes spawned per 0.5s
local DROPLPOS = 64 -- Raindrop light-tested positions per 0.5s cycle
local DROPPPOS = 2 -- Number of raindrops spawned per light-tested position
local RAINGAIN = 0.2 -- Rain sound volume
local NISVAL = 39 -- Overcast sky RGB value at night (brightness)
local DASVAL = 159 -- Overcast sky RGB value in daytime (brightness)
local FLAKRAD = 16 -- Radius in which flakes are created
local DROPRAD = 16 -- Radius in which drops are created

-- Precipitation noise

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


-- Some stuff

local difsval = DASVAL - NISVAL
local grad = 14 / 95
local yint = 1496 / 95


-- Initialise noise objects to nil

local nobj_temp = nil
local nobj_humid = nil
local nobj_prec = nil


-- Player tables

local handles = {}
local skybox = {} -- true/false. To not turn off skyboxes of other mods


-- Globalstep function

local os_time_0 = os.time()
local t_offset = math.random(0, 300000)

local timer = 0

minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 0.5 then
		return
	end

	timer = 0

	for _, player in ipairs(minetest.get_connected_players()) do
		local player_name = player:get_player_name()
		local ppos = player:getpos()
		-- Point just above player head, to ensure precipitation when swimming
		local pposy = math.floor(ppos.y) + 2
		if pposy >= YMIN and pposy <= YMAX then
			local pposx = math.floor(ppos.x)
			local pposz = math.floor(ppos.z)
			local ppos = {x = pposx, y = pposy, z = pposz}

			-- Heat, humidity and precipitation noises

			-- Time in seconds.
			-- Add the per-server-session random time offset to avoid identical behaviour
			-- each server session.
			local time = os.difftime(os.time(), os_time_0) - t_offset

			local nobj_temp = nobj_temp or minetest.get_perlin(np_temp)
			local nobj_humid = nobj_humid or minetest.get_perlin(np_humid)
			local nobj_prec = nobj_prec or minetest.get_perlin(np_prec)

			local nval_temp = nobj_temp:get2d({x = pposx, y = pposz})
			local nval_humid = nobj_humid:get2d({x = pposx, y = pposz})
			local nval_prec = nobj_prec:get2d({x = time, y = 0})

			-- Default Minetest Game biome system:
			-- Frozen biomes below heat 35
			-- deserts below line 14 * t - 95 * h = -1496
			-- h = (14 * t + 1496) / 95
			-- h = 14/95 * t + 1496/95
			-- where 14/95 is gradient and 1496/95 is 'y-intersection'
			-- h - 14/95 * t = 1496/95
			-- so area above line is
			-- h - 14/95 * t > 1496/95

			local freeze = nval_temp < 35
			local precip = nval_prec > PRECTHR and
				nval_humid - grad * nval_temp > yint

			-- Set sky
			if precip and not skybox[player_name] then
				-- Set overcast sky only if normal
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
				player:set_sky({r = sval, g = sval, b = sval + 16, a = 255},
					"plain", {}, false)
				skybox[player_name] = true
			elseif not precip and skybox[player_name] then
				-- Set normal sky only if skybox
				player:set_sky({}, "regular", {}, true)
				skybox[player_name] = nil
			end

			-- Stop looping sound.
			-- Stop sound if head below water level.
			if not precip or freeze or pposy < YWATER then
				if handles[player_name] then
					minetest.sound_stop(handles[player_name])
					handles[player_name] = nil
				end
			end

			-- Particles and sounds.
			-- Only if head above water level.
			if precip and pposy >= YWATER then
				if freeze then
					-- Snowfall particles
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
							local extime = math.min((spawny - YWATER) / 2, 10)

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
					-- Rainfall particles
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
								local extime = math.min((spawny - YWATER) / 12, 2)
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
					-- Start looping sound
					if not handles[player_name] then
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
		else
			-- Player outside y limits.
			-- Stop sound if playing.
			if handles[player_name] then
				minetest.sound_stop(handles[player_name])
				handles[player_name] = nil
			end
			-- Set normal sky if skybox
			if skybox[player_name] then
				player:set_sky({}, "regular", {}, true)
				skybox[player_name] = nil
			end
		end
	end
end)


-- On leaveplayer function

minetest.register_on_leaveplayer(function(player)
	local player_name = player:get_player_name()
	-- Stop sound if playing and remove handle
	if handles[player_name] then
		minetest.sound_stop(handles[player_name])
		handles[player_name] = nil
	end
	-- Remove skybox bool if necessary
	if skybox[player_name] then
		skybox[player_name] = nil
	end
end)
