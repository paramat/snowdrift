-- TODO rework logic

-- Parameters

local SCALP = 23 -- Time scale for precipitation variation in minutes
local PRET = -1 -- Precipitation noise threshold:
				-- -1 continuous, -0.3 two thirds the time,
				-- 0 half the time, 0.3 one third the time, 1 none.
local PPPCHA = 0.1 -- Per player processing chance.
local FLAKES = 8 -- Snowflake density
local NISVAL = 31 -- Snow clouds RGB value at night
local DASVAL = 127 -- Snow clouds RGB value in daytime
local SETTLE = false -- Snow collects on ground within 32 nodes of player
local SETCHA = 0.2 -- 0 to 1. Snow settling chance


-- Stuff

local difsval = DASVAL - NISVAL


-- Detect mapgen to select noise parameters

local TSEED, TOCTA, TPERS, TSCAL, TTHR
local mg_params = minetest.get_mapgen_params()
if mg_params.mgname == "v6" then
	TSEED = 9130
	TOCTA = 3
	TPERS = 0.5
	TSCAL = 500
	TTHR = -0.4
else
	TSEED = 5349
	TOCTA = 3
	TPERS = 0.5
	TSCAL = 1000
	TTHR = -0.4
end


-- Globalstep function

minetest.register_globalstep(function(dtime)
	local perlinp = minetest.get_perlin(813, 1, 0.5, SCALP)
	-- check if snow is currently falling
	if perlinp:get2d({x = os.clock() / 60, y = 0}) < PRET then
		return
	end 
	for _, player in ipairs(minetest.get_connected_players()) do
		-- randomise and spread processing load
		if math.random() > PPPCHA then
			return
		end
		-- check if undercover
		local ppos = player:getpos()
		if minetest.get_node_light(ppos, 0.5) ~= 15 then
			return
		end
		-- check if in snow biome
		local pposx = math.floor(ppos.x)
		local pposy = math.floor(ppos.y)
		local pposz = math.floor(ppos.z)
		local perlint = minetest.get_perlin(TSEED, TOCTA, TPERS, TSCAL)
		local noiset
		if mg_params.mgname == "v6" then
			noiset = perlint:get2d({x = pposx + 300, y = pposz + 100})
		else
			noiset = perlint:get2d({x = pposx, y = pposz})
		end
		-- if in snow biome
		if noiset <= TTHR then
			-- set sky to snow clouds
			-- first transition (24000 -) 4500, (1 -) 0.1875
			-- last transition (24000 -) 5750, (1 -) 0.2396
			if math.random() < 0.1 then
				local sval
				local time = minetest.get_timeofday()
				if time >= 0.5 then
					time = 1 - time
				end

				if time <= 0.1875 then
					sval = NISVAL
				elseif time >= 0.2396 then
					sval = DASVAL
				else
					sval = math.floor(NISVAL + ((time - 0.1875) / 0.0521) * difsval)
				end

				player:set_sky({r = sval, g = sval, b = sval + 16, a = 255}, "plain", {})
			end
			-- snowfall
			for flake = 1, FLAKES do
				minetest.add_particle({
					pos = {
						x = pposx - 32 + math.random(0, 63),
						y = pposy + 11 + math.random(),
						z = pposz - 8 + math.random(0, 63)
					},
					vel = {
						x = -0.1 + math.random() * 0.2,
						y = -1.1 + math.random() * 0.2,
						z = -2.1 + math.random() * 0.2
					},
					acc = {x = 0, y = 0, z = 0},
					expirationtime = 24,
					size = 2.8,
					collisiondetection = false,
					vertical = false,
					texture = "snowdrift_snowflake" .. math.random(1, 4) .. ".png",
					playername = player:get_player_name()
				})
			end
			-- snow settling
			if SETTLE and math.random() < SETCHA then -- settling snow
				local sposx = pposx - 32 + math.random(0, 63)
				local sposz = pposz - 32 + math.random(0, 63)
				-- check under open sky
				if minetest.get_node_light({x = sposx, y = pposy + 32, z = sposz}, 0.5) == 15 then
					for y = pposy + 32, pposy - 64, -1 do -- find surface
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
			end
		-- reset sky to normal
		elseif math.random() < 0.1 then
			player:set_sky({}, "regular", {})
		end
	end
end)
