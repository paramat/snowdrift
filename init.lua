-- Parameters

local PRECSPR = 11 -- Time scale for precipitation variation in minutes
local PRECTHR = -1 -- Precipitation noise threshold:
				-- -1 continuous, -0.3 two thirds the time,
				-- 0 half the time, 0.3 one third the time, 1 none.
local PROCHA = 0.1 -- Per player per globalstep processing chance
local FLAKES = 32 -- Snowflake density
local NISVAL = 39 -- Snow clouds RGB value at night
local DASVAL = 175 -- Snow clouds RGB value in daytime


-- Stuff

local difsval = DASVAL - NISVAL

local np_prec = {
	offset = 0,
	scale = 1,
	spread = {x = PRECSPR, y = PRECSPR, z = PRECSPR},
	seed = 813,
	octaves = 1,
	persist = 0,
	lacunarity = 2.0,
	--flags = ""
}

local np_temp, tempthr
local mg_params = minetest.get_mapgen_params()
if mg_params.mgname == "v6" then
	np_temp = {
		offset = 0,
		scale = 1,
		spread = {x = 500, y = 500, z = 500},
		seed = 9130,
		octaves = 3,
		persist = 0.5,
		lacunarity = 2.0,
		--flags = ""
	}
	tempthr = -0.4
else
	np_temp = {
		offset = 0,
		scale = 1,
		spread = {x = 1000, y = 1000, z = 1000},
		seed = 5349,
		octaves = 3,
		persist = 0.5,
		lacunarity = 2.0,
		--flags = ""
	}
	tempthr = -0.4
end


-- Globalstep function

minetest.register_globalstep(function(dtime)
	for _, player in ipairs(minetest.get_connected_players()) do
		-- randomise and spread processing load
		if math.random() > PROCHA then
			return
		end

		-- check if in snow biome
		local ppos = player:getpos()
		local pposx = math.floor(ppos.x)
		local pposy = math.floor(ppos.y)
		local pposz = math.floor(ppos.z)
		local nobj_temp = minetest.get_perlin(np_temp)
		local nval_temp
		if mg_params.mgname == "v6" then
			nval_temp = nobj_temp:get2d({x = pposx + 300, y = pposz + 100})
		else -- mgv5, mgv7
			nval_temp = nobj_temp:get2d({x = pposx, y = pposz})
		end
		local snowbiome = nval_temp <= tempthr

		-- check if snow is currently falling
		local nobj_prec = minetest.get_perlin(np_prec)
		local snowfall = nobj_prec:get2d({x = os.clock() / 60, y = 0}) >= PRECTHR

		-- check if player is outside
		local outside = minetest.get_node_light(ppos, 0.5) == 15

		-- occasionally reset player sky
		if math.random() < 0.1 then
			if snowbiome and snowfall then
				-- set sky to snow clouds
				local sval
				local time = minetest.get_timeofday()
				if time >= 0.5 then
					time = 1 - time
				end

				-- first transition (24000 -) 4500, (1 -) 0.1875
				-- last transition (24000 -) 5750, (1 -) 0.2396
				if time <= 0.1875 then
					sval = NISVAL
				elseif time >= 0.2396 then
					sval = DASVAL
				else
					sval = math.floor(NISVAL + ((time - 0.1875) / 0.0521) * difsval)
				end

				player:set_sky({r = sval, g = sval, b = sval + 16, a = 255}, "plain", {})
			else -- reset sky to normal
				player:set_sky({}, "regular", {})
			end
		end

		if snowbiome and snowfall and outside then
			-- snowfall
			for flake = 1, FLAKES do
				minetest.add_particle({
					pos = {
						x = pposx - 48 + math.random(0, 95),
						y = pposy + 12 + math.random(),
						z = pposz - 36 + math.random(0, 95)
					},
					vel = {
						x = -0.1 + math.random() * 0.2,
						y = -1.6 + math.random() * 0.2,
						z = -1.1 + math.random() * 0.2
					},
					acc = {x = 0, y = 0, z = 0},
					expirationtime = 16,
					size = 2.8,
					collisiondetection = false,
					vertical = false,
					texture = "snowdrift_snowflake" .. math.random(1, 4) .. ".png",
					playername = player:get_player_name()
				})
			end
		end
	end
end)


			--[[ snow settling
			if SETTLE and math.random() < SETCHA then -- settling snow
				local sposx = pposx - 32 + math.random(0, 63)
				local sposz = pposz - 32 + math.random(0, 63)
				-- check under open sky
				if minetest.get_node_light({x = sposx, y = pposy + 32, z = sposz}, 0.5) == 15 then
					for y = pposy + 48, pposy - 48, -1 do -- find surface
						local nodename = minetest.get_node({x = sposx, y = y, z = sposz}).name
						if nodename ~= "air" and nodename ~= "ignore" then
							if nodename == "default:desert_sand" -- no snow on these
							or nodename == "default:desert_stone"
							or nodename == "default:water_source" then
								break
							else -- check node drawtype
								local drawtype = minetest.registered_nodes[nodename].drawtype
								if drawtype == "normal"
								or drawtype == "glasslike"
								or drawtype == "glasslike_framed"
								or drawtype == "allfaces"
								or drawtype == "allfaces_optional" then
									if nodename == "default:dirt_with_grass" then
										minetest.add_node(
											{x = sposx, y = y, z = sposz},
											{name="default:dirt_with_snow"}
										)
									end
									minetest.add_node(
										{x = sposx, y = y + 1, z = sposz},
										{name="default:snow"}
									)
									break
								-- dirt with snow added under plants
								elseif drawtype == "plantlike" then
									local unodename = minetest.get_node(
										{x = sposx, y = y - 1, z = sposz}).name
									if unodename == "default:dirt_with_grass" then
										minetest.add_node({x = sposx, y = y - 1, z = sposz},
											{name="default:dirt_with_snow"})
									end
									break
								else
									break
								end
							end
						end
					end
				end
			end --]]
