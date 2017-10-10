-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.

local mod_utils = require "scripts.shared.utils"

local mod_ground_mode = require "scripts.shared.ground_mode"

local M = {}

-- Sensor data
M.POS_LOW = -4
M.POS_BOTTOM = -20

M.POS_LEFT = -10
M.POS_LEFT_S = -9
M.POS_CENTRE = 0
M.POS_RIGHT = 10
M.POS_RIGHT_S = 9

M.SENSOR_LEFT_LOW = vmath.vector3(M.POS_LEFT, M.POS_LOW, 0)
M.SENSOR_RIGHT_LOW = vmath.vector3(M.POS_RIGHT, M.POS_LOW, 0)

M.SENSOR_LEFT_BOTTOM = vmath.vector3(M.POS_LEFT_S, M.POS_BOTTOM, 0)
M.SENSOR_RIGHT_BOTTOM = vmath.vector3(M.POS_RIGHT_S, M.POS_BOTTOM, 0)

-- New Sensor Data Format
-- Wall sensors
M.SENSOR_DATA_LEFT_LOW = {
	x_offset = M.POS_LEFT,
	y_offset = M_POS_LOW,
	
	x_push = mod_utils.sign(-M.POS_LEFT),
	y_push = 0
}

M.SENSOR_DATA_RIGHT_LOW = {
	x_offset = M.POS_RIGHT,
	y_offset = M_POS_LOW,
	
	x_push = mod_utils.sign(-M.POS_RIGHT),
	y_push = 0
}
M.SENSOR_COLLECTION_WALL = {M.SENSOR_DATA_LEFT_LOW, M.SENSOR_DATA_RIGHT_LOW}

-- Ground sensors
M.SENSOR_DATA_LEFT_BOTTOM = {
	x_offset = M.POS_LEFT_S,
	y_offset = M_POS_BOTTOM,
	
	x_push = 0,
	y_push = mod_utils.sign(-M.POS_BOTTOM)
}

M.SENSOR_DATA_RIGHT_BOTTOM = {
	x_offset = M.POS_RIGHT_S,
	y_offset = M_POS_BOTTOM,
	
	x_push = 0,
	y_push = mod_utils.sign(-M.POS_BOTTOM)
}
M.SENSOR_COLLECTION_GROUND = {M.SENSOR_DATA_LEFT_BOTTOM, M.SENSOR_DATA_RIGHT_BOTTOM}



-- Calculate the world sensor position offset and push out direction from the given ground mode,
-- and relative sensor data. Returns a table containing the offset and push as two vmath.vector3 values
function M.get_ground_oriented_sensor_data(sensor_data, ground_mode)
	local up = mod_ground_mode.SANIC_GM_UP[ground_mode]
	local right = mod_ground_mode.SANIC_GM_RIGHT[ground_mode]
	
	local offset = vmath.vector3(
									right*x_offset,
									up*y_offset,
									0
								)
	local push = vmath.vector3(
									right*x_push,
									up*y_push,
									0
								)
								
	return {offset = offset, push = push}
end



return M