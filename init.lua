-- snowdrift 0.2.5 by paramat
-- For latest stable Minetest and back to 0.4.6
-- Depends default
-- Licenses: code WTFPL, textures CC BY-SA

-- Parameters

local SCALP = 3 -- Time scale for precipitation in minutes
local PRET = 0 -- -1 to 1. Precipitation threshold: 1 none, -1 continuous, 0 half the time, 0.3 one third the time
local PPPCHA = 0.1 -- 0 to 1. Per player processing chance. Controls and randomizes processing load
local SETCHA = 0.2 -- 0 to 1. Snow settling chance
local DROPS = 16 -- Rainfall heaviness
local SNOW = true -- Snowfall below temperature threshold
local SETTLE = true -- Snow collects on ground within 32 nodes of player
local RAIN = true -- Rain above humidity threshold
local THOVER = false -- Instead use a temperature and humidity system with
			-- snow in overlap of cold and humid areas, else rain in humid areas
			
-- Temperature noise parameters
local SEEDT = 112 -- 112 These are default noise parameters from snow mod by Splizard
local OCTAT = 3	 -- 3		use these for snowfall in those snow biomes
local PERST = 0.5 -- 0.5
local SCALT = 150 -- 150
local TET = -0.53 -- -0.53 Temperature threshold for snow

-- Humidity noise parameters
local SEEDH = 72384 -- 72384 These are default noise parameters for mapgen V6 humidity
local OCTAH = 4 -- 4		note these cause rain in deserts
local PERSH = 0.66 -- 0.66
local SCALH = 500 -- 500
local HUT = -4 -- Humidity threshold for rain

-- Stuff

snowdrift = {}

-- Globalstep function

minetest.register_globalstep(function(dtime)
	local perlinp = minetest.get_perlin(813, 1, 0.5, SCALP)
	if perlinp:get2d({x = os.clock()/60, y = 0}) < PRET then
		return
	end 
	for _, player in ipairs(minetest.get_connected_players()) do
		if math.random() > PPPCHA then
			return
		end
		local ppos = player:getpos()
		if minetest.get_node_light(ppos, 0.5) ~= 15 then
			return
		end
		local pposx = math.floor(ppos.x)
		local pposy = math.floor(ppos.y)
		local pposz = math.floor(ppos.z)
		local snow = false
		local rain = false
		local noiset
		local noiseh
		if SNOW or THOVER then
			local perlint = minetest.get_perlin(SEEDT, OCTAT, PERST, SCALT)
			noiset = perlint:get2d({x = pposx, y = pposz})
		end
		if RAIN or THOVER then	
			local perlinh = minetest.get_perlin(SEEDH, OCTAH, PERSH, SCALH)
			noiseh = perlinh:get2d({x = pposx, y = pposz})
		end
		if THOVER then
			if noiset < TET and noiseh > HUT then
				snow = true
			elseif noiseh > HUT then
				rain = true
			end
		elseif SNOW then
			if -noiset < TET then -- negative sign because snow mod noise is 'coldness'
				snow = true
			elseif RAIN then
				if noiseh > HUT then
					rain = true
				end
			end
		elseif RAIN then
			if noiseh > HUT then
				rain = true
			end
		end
		if snow then
			minetest.add_particle(
				{x=pposx-32+math.random(0,63), y=pposy+16, z=pposz-16+math.random(0,63)}, -- posi
				{x=math.random()/5-0.1, y=math.random()/5-1.1, z=math.random()/5-1.1}, -- velo
				{x=math.random()/50-0.01, y=math.random()/50-0.01, z=math.random()/50-0.01}, -- acce
				32,
				2.8,
				false,
				"snowdrift_snowflake1.png",
				player:get_player_name()
			)
			minetest.add_particle(
				{x=pposx-32+math.random(0,63), y=pposy+16, z=pposz-16+math.random(0,63)}, -- posi
				{x=math.random()/5-0.1, y=math.random()/5-1.1, z=math.random()/5-1.1}, -- velo
				{x=math.random()/50-0.01, y=math.random()/50-0.01, z=math.random()/50-0.01}, -- acce
				32,
				2.8,
				false,
				"snowdrift_snowflake2.png",
				player:get_player_name()
			)
			minetest.add_particle(
				{x=pposx-32+math.random(0,63), y=pposy+16, z=pposz-16+math.random(0,63)}, -- posi
				{x=math.random()/5-0.1, y=math.random()/5-1.1, z=math.random()/5-1.1}, -- velo
				{x=math.random()/50-0.01, y=math.random()/50-0.01, z=math.random()/50-0.01}, -- acce
				32,
				2.8,
				false,
				"snowdrift_snowflake3.png",
				player:get_player_name()
			)
			minetest.add_particle(
				{x=pposx-32+math.random(0,63), y=pposy+16, z=pposz-16+math.random(0,63)}, -- posi
				{x=math.random()/5-0.1, y=math.random()/5-1.1, z=math.random()/5-1.1}, -- velo
				{x=math.random()/50-0.01, y=math.random()/50-0.01, z=math.random()/50-0.01}, -- acce
				32,
				2.8,
				false,
				"snowdrift_snowflake4.png",
				player:get_player_name()
			)
			if SETTLE and math.random() < SETCHA then -- settling snow
				local sposx = pposx - 32 + math.random(0, 63)
				local sposz = pposz - 32 + math.random(0, 63)
				if minetest.get_node_light({x=sposx, y=pposy+32, z=sposz}, 0.5) == 15 then -- check under open sky
					for y = pposy + 32, pposy - 64, -1 do -- find surface
						local nodename = minetest.get_node({x=sposx, y=y, z=sposz}).name
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
										minetest.add_node({x=sposx, y=y, z=sposz}, {name="default:dirt_with_snow"})
									end
									minetest.add_node({x=sposx, y=y+1, z=sposz}, {name="default:snow"})
									break
								elseif drawtype == "plantlike" then -- dirt with snow added under plants
									local unodename = minetest.get_node({x=sposx, y=y-1, z=sposz}).name
									if unodename == "default:dirt_with_grass" then
										minetest.add_node({x=sposx, y=y-1, z=sposz}, {name="default:dirt_with_snow"})
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
		end
		if rain then
			for drop = 1, DROPS do
				minetest.add_particle(
					{x=pposx-24+math.random(0,48), y=pposy+16, z=pposz-24+math.random(0,48)}, -- posi
					{x=0, y=-8, z=-1}, -- velo
					{x=0, y=0, z=0}, -- acce
					4,
					2.8,
					false,
					"snowdrift_raindrop.png",
					player:get_player_name()
				)
			end
		end			
	end
end)