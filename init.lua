-- Snowdrift 0.2.0 by paramat
-- For latest stable Minetest and back to 0.4.6
-- Depends default
-- Licenses: Code WTFPL. Textures CC BY-SA.
-- This is intended to be used as alternative snowfall for the snow mod by Splizard.
-- The code is partly derived from weather mod by Jeija and snow mod version 1.8 by Splizard.

-- Parameters

local PROCHA = 0.5 -- (0 to 1) -- Processing chance

local SEEDS = 112 -- 112 -- Snow mod default biome noise parameters
local OCTAS = 3 -- 3
local PERSS = 0.5 -- 0.5
local SCALS = 64 -- 150
local SNOWT = 0.4 -- 0.53

local SEEDR = -90000667 
local OCTAR = 3
local PERSR = 0.5
local SCALR = 64
local RAINT = 0.4

-- Stuff

snowdrift = {}

-- Globalstep function

minetest.register_globalstep(function(dtime)
	-- if not raining at this time then return
	for _, player in ipairs(minetest.get_connected_players()) do
		if math.random() > PROCHA then
			return
		end
		local ppos = player:getpos()
		if minetest.env:get_node_light(ppos, 0.5) ~= 15 then
			return
		end
		local perlins = minetest.env:get_perlin(SEEDS, OCTAS, PERSS, SCALS)
		local noises = perlins:get2d({x = ppos.x, y = ppos.z})
		if noises > SNOWT then -- if snow biome
			if math.random() < noises - SNOWT then
				minetest.add_particle(
					{x = ppos.x - 64 + math.random(0, 128), y= ppos.y + 16, z= ppos.z - 48 + math.random(0, 128)}, -- posi
					{x = math.random() / 5 - 0.1, y = math.random() / 5 - 1.1, z = math.random() / 5 - 1.1}, -- velo
					{x = math.random() / 50 - 0.01, y = math.random() / 50 - 0.01, z = math.random() / 50 - 0.01}, -- acce
					32,
					2.8,
					false,
					"snowdrift_snowflake1.png",
					player:get_player_name()
				)
				minetest.add_particle(
					{x = ppos.x - 64 + math.random(0, 128), y= ppos.y + 16, z= ppos.z - 48 + math.random(0, 128)}, -- posi
					{x = math.random() / 5 - 0.1, y = math.random() / 5 - 1.1, z = math.random() / 5 - 1.1}, -- velo
					{x = math.random() / 50 - 0.01, y = math.random() / 50 - 0.01, z = math.random() / 50 - 0.01}, -- acce
					32,
					2.8,
					false,
					"snowdrift_snowflake2.png",
					player:get_player_name()
				)
				minetest.add_particle(
					{x = ppos.x - 64 + math.random(0, 128), y= ppos.y + 16, z= ppos.z - 48 + math.random(0, 128)}, -- posi
					{x = math.random() / 5 - 0.1, y = math.random() / 5 - 1.1, z = math.random() / 5 - 1.1}, -- velo
					{x = math.random() / 50 - 0.01, y = math.random() / 50 - 0.01, z = math.random() / 50 - 0.01}, -- acce
					32,
					2.8,
					false,
					"snowdrift_snowflake3.png",
					player:get_player_name()
				)
				minetest.add_particle(
					{x = ppos.x - 64 + math.random(0, 128), y= ppos.y + 16, z= ppos.z - 48 + math.random(0, 128)}, -- posi
					{x = math.random() / 5 - 0.1, y = math.random() / 5 - 1.1, z = math.random() / 5 - 1.1}, -- velo
					{x = math.random() / 50 - 0.01, y = math.random() / 50 - 0.01, z = math.random() / 50 - 0.01}, -- acce
					32,
					2.8,
					false,
					"snowdrift_snowflake4.png",
					player:get_player_name()
				)
			end
		else -- check rain noise
			local perlinr = minetest.get_perlin(SEEDR, OCTAR, PERSR, SCALR)
			local noiser = perlinr:get2d({x = ppos.x, y = ppos.z})
			if math.random() < noiser - RAINT then
				for drop = 1, 4 do
					minetest.add_particle(
						{x = ppos.x - 16 + math.random(0, 32), y= ppos.y + 16, z= ppos.z - 16 + math.random(0, 32)}, -- posi
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
	end
end)