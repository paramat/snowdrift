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


-- For sound
-- ==================

-- Constants here because will probably become variables

 -- Sound volume
local RAINGAIN = 0.2
local SNOWGAIN = 0.3


snowdrift.sounds_data = {}

snowdrift.sounds_data.rain = {song = "snowdrift_rain", base_gain = RAINGAIN}
snowdrift.sounds_data.snow = {song = "cobratronik_wind_artic_cold", base_gain = SNOWGAIN}
snowdrift.sounds_data.clear = nil








