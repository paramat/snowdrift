--- snowdrift/futuresettings.lua
-- That file contain constants to configure snowdrift.
-- Will probably change into a more conventionnal file of configuration (like settingstype)


-- Globalstep cycle (seconds)
snowdrift.GSCYCLE = 0.5


-- Frequentcy of precipitation
-- ===========================

-- Set to world's water level or level of lowest open area,
-- calculations are disabled below this y.
snowdrift.YLIMIT = 1 
				
-- Time scale for precipitation variation in minutes
snowdrift.PRECSPR = 6

-- Precipitation offset (higher = rains more often)
snowdrift.PRECOFF = -0.4


-- Color of clouds
-- ===============

-- Clouds RGB value at night
snowdrift.NISVAL = 39

-- Clouds RGB value in daytime
snowdrift.DASVAL = 175


-- Behaviour of sky particules
-- ===========================

-- Whether particles collide with nodes
snowdrift.COLLIDE = true

-- Rain
snowdrift.DROPS = 64 -- Raindrops per cycle
snowdrift.RAINBOX = {x = -8, y = 8, z = -8}
snowdrift.RAINVELOCITY = {x = 0.0, y = -10.0, z = 0.0}
snowdrift.RAINACCELERATION = {x = 0, y = 0, z = 0}


-- Snow
snowdrift.FLAKES = 16 -- Snowflakes per cycle
snowdrift.SNOWBOX = {x = -24, y = 8, z = -20}
snowdrift.SNOWVELOCITY = {x = 0.0, y = -2.0, z = -1.0}
snowdrift.SNOWACCELERATION = {x = 0, y = 0, z = 0}



-- Behaviour of sound
-- ==================

-- minimum of percent of emmited particles to play a sound
snowdrift.OUTSIDE_QUOTA = 0.3


