--- snowdrift/src/utils.lua
--Small librairy of functions that are not specific at snowdrift.


-- Test inside / outside

--- Test if the pos is outside using ligth at midday.
-- @param pos position to test
-- @return true if outside
function snowdrift.is_outside(pos)
	return (minetest.get_node_light(pos, 0.5) == 15)
end


--- Alias for "not snowdrift.is_outside(pos)".
-- @param pos position to test
-- @return true if inside
-- @see snowdrift.is_outside(pos)
function snowdrift.is_inside(pos)
	return (not snowdrift.is_outside(pos))
end


