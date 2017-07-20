
local FLAKES = 16 -- Snowflakes per cycle
local DROPS = 64 -- Raindrops per cycle
local COLLIDE = true -- Whether particles collide with nodes



					-- Snowfall
					for flake = 1, FLAKES do
						local pos = {
							x = pposx - 24 + math.random(0, 47),
							y = pposy + 8 + math.random(0, 1),
							z = pposz - 20 + math.random(0, 47)
							}
						if minetest.get_node_light(pos, 0.5) == 15 then
							minetest.add_particle({
								pos = pos,
								velocity = {
									x = 0.0,
									y = -2.0,
									z = -1.0
								},
								acceleration = {x = 0, y = 0, z = 0},
								expirationtime = 8.5,
								size = 2.8,
								collisiondetection = COLLIDE,
								collision_removal = true,
								vertical = false,
								texture = "snowdrift_snowflake" .. math.random(1, 4) .. ".png",
								playername = player:get_player_name()
							})
							outside_quota = outside_quota + 1 / FLAKES
						end
					end


					-- Rainfall
					for flake = 1, DROPS do
						local pos = {
							x = pposx - 8 + math.random(0, 16),
							y = pposy + 8 + math.random(0, 5),
							z = pposz - 8 + math.random(0, 16)
							}
						if minetest.get_node_light(pos, 0.5) == 15 then
							minetest.add_particle({
								pos = pos,
								velocity = {
									x = 0.0,
									y = -10.0,
									z = 0.0
								},
								acceleration = {x = 0, y = 0, z = 0},
								expirationtime = 2.1,
								size = 2.8,
								collisiondetection = COLLIDE,
								collision_removal = true,
								vertical = true,
								texture = "snowdrift_raindrop.png",
								playername = player:get_player_name()
							})
							outside_quota = outside_quota + 1 / DROPS
						end
					end





