--[[ snowdrift/src/utils.lua
Small librairy of functions that are not specific at snowdrift.
Version : release v0.7.0
]]


--[[ snowdrift.is_outside(pos)

]]
function snowdrift.is_outside(pos)
	return (minetest.get_node_light(pos, 0.5) == 15)
end


--[[ snowdrift.is_inside(pos)

]]
function snowdrift.is_inside(pos)
	return (not snowdrift.is_outside(pos))
end

