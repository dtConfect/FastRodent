-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.

local mod_utils = require "scripts.shared.utils"

local mod_ground_mode = require "scripts.shared.ground_mode"

local M = {}


-- Sensor data
M.POS_LOW = -4
M.POS_BOTTOM = -21

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
	offset = vmath.vector3(M.POS_LEFT, M.POS_LOW, 0),
	ground_mode = mod_ground_mode.SANIC_GROUND_MODE_RIGHT
}

M.SENSOR_DATA_RIGHT_LOW = {
	offset = vmath.vector3(M.POS_RIGHT, M.POS_LOW, 0),
	ground_mode = mod_ground_mode.SANIC_GROUND_MODE_LEFT
}
M.SENSOR_COLLECTION_WALL = {M.SENSOR_DATA_LEFT_LOW, M.SENSOR_DATA_RIGHT_LOW}

-- Ground sensors
M.SENSOR_DATA_LEFT_BOTTOM = {
	offset = vmath.vector3(M.POS_LEFT_S, M.POS_BOTTOM, 0),
	ground_mode = mod_ground_mode.SANIC_GROUND_MODE_OVER
}

M.SENSOR_DATA_RIGHT_BOTTOM = {
	offset = vmath.vector3(M.POS_RIGHT_S, M.POS_BOTTOM, 0),
	ground_mode = mod_ground_mode.SANIC_GROUND_MODE_OVER
}
M.SENSOR_COLLECTION_GROUND = {M.SENSOR_DATA_LEFT_BOTTOM, M.SENSOR_DATA_RIGHT_BOTTOM}


function M.copy_sensor_data(sensor_data)
	return {offset = sensor_data.offset, pos = sensor_data.pos, ground_mode = sensor_data.ground_mode}
end

function M.orient_sensor_offset(sensor_data, character_ground_mode)
	assert(sensor_data.pos == nil, "Rotating a sensor_data whose pos is not nil.")
	
	local up = mod_ground_mode.SANIC_GM_UP[character_ground_mode]
	local right = mod_ground_mode.SANIC_GM_RIGHT[character_ground_mode]
	
	sensor_data.offset = right*sensor_data.offset.x + up*sensor_data.offset.y

	sensor_data.ground_mode = mod_utils.wrap((sensor_data.ground_mode + character_ground_mode-1), 1, mod_ground_mode.SANIC_GROUND_MODES)
end

function M.set_sensor_pos(sensor_data, world_pos)
	sensor_data.pos = sensor_data.offset + world_pos	
end

function M.offset_sensor_pos(sensor_data, pos_delta)
	sensor_data.pos = sensor_data.pos + pos_delta	
end



return M