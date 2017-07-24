--- snowdrift/src/futuresettings.lua
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


-- Behaviour of particules
-- =======================

-- Whether particles collide with nodes
snowdrift.COLLIDE = true


-- Behaviour of sound
-- ==================

-- minimum of percent of emmited particles to play a sound
snowdrift.OUTSIDE_QUOTA = 0.3


