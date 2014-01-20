-- snowdrift 0.2.2 by paramat
-- For latest stable Minetest and back to 0.4.6
-- Depends default
-- Licenses: code WTFPL, textures CC BY-SA

-- Removed snow noise offset

-- Parameters

local PROCHA = 0.2 -- (0 to 1) -- Per player processing chance, randomizes and spreads processing load
local DROPS = 8 -- Rainfall heaviness
local SNOWV6 = true -- Snowfall in snow biomes of snow mod by Splizard
local RAIN = false -- Rain above humidity threshold
local THOVER = false -- Instea use a temperature and humidity system with
			-- snow in overlap of cold and humid
			-- else rain in humid areas
local SEEDT = 112 -- 112 -- If THOVER = true, set these to your mapgen's temperature noise parameters
local OCTAT = 3	 -- 3
local PERST = 0.5 -- 0.5
local SCALT = 150 -- 150

local TET = -0.53 -- -0.53 -- Temperature threshold for snow
				-- If SNOWV6 = true set to -0.53
local SEEDH = 72384 -- 72384 -- Set these to your mapgen's humidity noise parameters
local OCTAH = 4 -- 4
local PERSH = 0.66 -- 0.66
local SCALH = 500 -- 500

local HUT = 0.5 -- 0.5 -- Humidity threshold for rain

-- Stuff

snowdrift = {}

-- Globalstep function

minetest.register_globalstep(function(dtime)
	-- TODO if not raining at this time then return
	for _, player in ipairs(minetest.get_connected_players()) do
		if math.random() > PROCHA then
			return
		end
		local ppos = player:getpos()
		if minetest.get_node_light(ppos, 0.5) ~= 15 then
			return
		end
		local snow = false
		local rain = false
		local noiset
		local noiseh
		if SNOWV6 or THOVER then
			local perlint = minetest.get_perlin(SEEDT, OCTAT, PERST, SCALT)
			noiset = perlint:get2d({x = ppos.x, y = ppos.z})
		end
		if RAIN or THOVER then	
			local perlinh = minetest.get_perlin(SEEDH, OCTAH, PERSH, SCALH)
			noiseh = perlinh:get2d({x = ppos.x, y = ppos.z})
		end
		if THOVER then
			if noiset < TET and noiseh > HUT then
				snow = true
			elseif noiseh > HUT then
				rain = true
			end
		elseif SNOWV6 then
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
				{x = ppos.x - 64 + math.random(0, 128), y = ppos.y + 16, z = ppos.z - 48 + math.random(0, 128)}, -- posi
				{x = math.random() / 5 - 0.1, y = math.random() / 5 - 1.1, z = math.random() / 5 - 1.1}, -- velo
				{x = math.random() / 50 - 0.01, y = math.random() / 50 - 0.01, z = math.random() / 50 - 0.01}, -- acce
				32,
				2.8,
				false,
				"snowdrift_snowflake1.png",
				player:get_player_name()
			)
			minetest.add_particle(
				{x = ppos.x - 64 + math.random(0, 128), y = ppos.y + 16, z = ppos.z - 48 + math.random(0, 128)}, -- posi
				{x = math.random() / 5 - 0.1, y = math.random() / 5 - 1.1, z = math.random() / 5 - 1.1}, -- velo
				{x = math.random() / 50 - 0.01, y = math.random() / 50 - 0.01, z = math.random() / 50 - 0.01}, -- acce
				32,
				2.8,
				false,
				"snowdrift_snowflake2.png",
				player:get_player_name()
			)
			minetest.add_particle(
				{x = ppos.x - 64 + math.random(0, 128), y = ppos.y + 16, z = ppos.z - 48 + math.random(0, 128)}, -- posi
				{x = math.random() / 5 - 0.1, y = math.random() / 5 - 1.1, z = math.random() / 5 - 1.1}, -- velo
				{x = math.random() / 50 - 0.01, y = math.random() / 50 - 0.01, z = math.random() / 50 - 0.01}, -- acce
				32,
				2.8,
				false,
				"snowdrift_snowflake3.png",
				player:get_player_name()
			)
			minetest.add_particle(
				{x = ppos.x - 64 + math.random(0, 128), y = ppos.y + 16, z = ppos.z - 48 + math.random(0, 128)}, -- posi
				{x = math.random() / 5 - 0.1, y = math.random() / 5 - 1.1, z = math.random() / 5 - 1.1}, -- velo
				{x = math.random() / 50 - 0.01, y = math.random() / 50 - 0.01, z = math.random() / 50 - 0.01}, -- acce
				32,
				2.8,
				false,
				"snowdrift_snowflake4.png",
				player:get_player_name()
			)
		end
		if rain then
			for drop = 1, DROPS do
				minetest.add_particle(
					{
						x = ppos.x - 16 + math.random(0, 32),
						y = ppos.y + 16,
						z = ppos.z - 16 + math.random(0, 32)
					}, -- posi
					{x = 0, y = -8, z = -1}, -- velo
					{x = 0, y = 0, z = 0}, -- acce
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