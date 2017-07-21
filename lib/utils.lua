--[[ snowdrift/src/utils.lua
Small librairy of functions that are not specific at snowdrift.
Version :
]]


-- Function on vectors

--[[ snowdrift.addvectors((v1, v2)
Add the two given vectors.
return the result as a vector.
]]
function snowdrift.addvectors(v1, v2)
	return {x=v1.x+v2.x, y=v1.y+v2.y, z=v1.z+v2.z}
end

