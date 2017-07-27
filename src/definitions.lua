--- snowdrift/src/definitions.lua
-- Define tables of data for snowdrift


-- For calculations
-- ================

snowdrift.np_prec = {
	offset = 0,
	scale = 1,
	spread = {x = snowdrift.PRECSPR, y = snowdrift.PRECSPR, z = snowdrift.PRECSPR},
	seed = 813,
	octaves = 1,
	persist = 0,
	lacunarity = 2.0
}

-- These 2 must match biome heat and humidity noise parameters for a world
snowdrift.np_temp = {
	offset = 50,
	scale = 50,
	spread = {x = 1000, y = 1000, z = 1000},
	seed = 5349,
	octaves = 3,
	persist = 0.5,
	lacunarity = 2.0
}

snowdrift.np_humid = {
	offset = 50,
	scale = 50,
	spread = {x = 1000, y = 1000, z = 1000},
	seed = 842,
	octaves = 3,
	persist = 0.5,
	lacunarity = 2.0
}


-- For sky brightness
-- ==================

snowdrift.difsval = snowdrift.DASVAL - snowdrift.NISVAL


-- For sky particles
-- =================


-- TODO These functions should be replaced by a analysis of folder (or a convention like snowdrift_snowflake.X.png if it work with textures)

-- Create a table with the textures to use, one texture is chosen randomly
local snowtexture_table = function ()
	local number_of_texture = 4
	local texture_table = {}
	for i = 1, number_of_texture do
		table.insert(texture_table, ("snowdrift_snowflake" .. i .. ".png"))
	end
	return texture_table
end


local raintexture_table = function ()
	return {"snowdrift_raindrop.png"}
end


--- Stock data of particules.
snowdrift.particles_data = {}

snowdrift.particles_data.rain = {
	base_number = snowdrift.DROPS,
	min_box = {x = -8, y = 8, z = -8},
	random_vector = {x = 16, y = 5, z = 16},
	base_velocity = {x = 0.0, y = -10.0, z = 0.0},
	base_acceleration = {x = 0, y = 0, z = 0},
	expirationtime = 2.1,
	size = 2.8,
	texture = raintexture_table()
}

snowdrift.particles_data.snow = {
	base_number = snowdrift.FLAKES,
	min_box = {x = -24, y = 8, z = -20},
	random_vector = {x = 47, y = 1, z = 47},
	base_velocity = {x = 0.0, y = -2.0, z = -1.0},
	base_acceleration = {x = 0, y = 0, z = 0},
	expirationtime = 8.5,
	size = 2.8,
	texture = snowtexture_table()
}

snowdrift.particles_data.clear = nil


-- For sounds
-- ==========

-- Constants here because will probably become variables

 -- Sound volume
local RAINGAIN = 0.2
local SNOWGAIN = 0.2


--- Stock data of sounds.
snowdrift.sounds_data = {}

snowdrift.sounds_data.rain = {song = "snowdrift_rain", base_gain = RAINGAIN}
snowdrift.sounds_data.snow = {song = "cobratronik_wind_artic_cold", base_gain = SNOWGAIN}
snowdrift.sounds_data.clear = nil

