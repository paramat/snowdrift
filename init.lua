-- Snowdrift 0.1.1 by paramat
-- For latest stable Minetest and back to 0.4.6
-- Depends default
-- Licenses: Code WTFPL. Textures CC BY-SA.
-- This is intended to be used as alternative snowfall for the snow mod by Splizard.
-- The code is partly derived from weather mod by Jeija and snow mod version 1.8 by Splizard.

-- Parameters

local MAXCHA = 1 -- (0 to 1) Maximum per globalstep chance of processing a player. Controls snow density and processing load.

local SEED1 = 112 -- 112 -- These 5 parameters should match the values you use in snow mod.
local OCTA1 = 3 -- 3
local PERS1 = 0.5 -- 0.5
local SCAL1 = 256 -- 150 -- Large scale size of snow biomes.
local SNOTHR = 0.4 -- 0.53 -- Perlin noise > SNOTHR for snow biome.

-- Stuff

snowdrift = {}

-- Globalstep function

minetest.register_globalstep(function(dtime)
	for _, player in ipairs(minetest.get_connected_players()) do
		if math.random() > MAXCHA then
			return
		end
		local ppos = player:getpos()
		if minetest.env:get_node_light(ppos, 0.5) ~= 15 then
			return
		end
		local perlin1 = minetest.env:get_perlin(SEED1, OCTA1, PERS1, SCAL1)
		local noise1 = perlin1:get2d({x = ppos.x, y = ppos.z})
		local biome = noise1 - SNOTHR
		if math.random() > biome then
			return
		end
		local posi = {x = ppos.x - 64 + math.random(0, 128), y= ppos.y + 16, z= ppos.z - 48 + math.random(0, 128)}
		local velo = {x = math.random() / 5 - 0.1, y = math.random() / 5 - 1.1, z = math.random() / 5 - 1.1}
		local acce = {x = math.random() / 50 - 0.01, y = math.random() / 50 - 0.01, z = math.random() / 50 - 0.01}
		minetest.add_particle(
			posi,
			velo,
			acce,
			32,
			2.8,
			false, "snowdrift_snowflake1.png", player:get_player_name())
		local posi = {x = ppos.x - 64 + math.random(0, 128), y= ppos.y + 16, z= ppos.z - 48 + math.random(0, 128)}
		local velo = {x = math.random() / 5 - 0.1, y = math.random() / 5 - 1.1, z = math.random() / 5 - 1.1}
		local acce = {x = math.random() / 50 - 0.01, y = math.random() / 50 - 0.01, z = math.random() / 50 - 0.01}
		minetest.add_particle(
			posi,
			velo,
			acce,
			32,
			2.8,
			false, "snowdrift_snowflake2.png", player:get_player_name())
	end
end)
