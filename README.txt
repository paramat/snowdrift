-- Snowdrift 0.1.1 by paramat
-- For latest stable Minetest and back to 0.4.6
-- Depends default
-- Licenses: Code WTFPL. Textures CC BY-SA.
-- This is intended to be used as alternative snowfall for the snow mod by Splizard.
-- The code is partly derived from weather mod by Jeija and snow mod version 1.8 by Splizard.

Version 0.1.0
---------------
* Snowfall only in the snow biomes of snow mod by Splizard. You will need to disable snow mod snowfall.
* Minimal processing for less powerful computers.
* Snowfall is only seen by a player if the player is outside under open sky.
* Each snowflake has it's own random trajectory, initial position, initial velocity and acceleration.
* Snow falls at an average of 1m/s.
* Snow drifts southwards at an average of 1m/s, a slightly lower speed than the southward cloud drift.
* Snowflakes are sized to match 16x16 texture resolution and the icons used in my texture pack.
* The snow box around the player is 128x128x32 nodes in size.
* Parameter PROCHA controls snow density and processing load, default is 0.5, try 1 for denser snow.

Version 0.1.1
-------------
* Mod is too light, doubled maximum snow density, added second snowflake design with a square symmetry.
* Snow density is now smoothly varied by how deep into a snow biome a player is.
