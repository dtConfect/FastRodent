-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.

local mod_tile_helper = require "scripts.shared.tile_helper"
local mod_utils = require "scripts.shared.utils"

local M = {}



-- Define sanic's ground modes
M.SANIC_GROUND_MODE_OVER = 1
M.SANIC_GROUND_MODE_LEFT = 2
M.SANIC_GROUND_MODE_UNDER = 3
M.SANIC_GROUND_MODE_RIGHT = 4

M.SANIC_GROUND_MODES = 4

M.GROUND_MODES_DIV_TABLE = mod_utils.create_division_table(M.SANIC_GROUND_MODES)
function M.get_division(angle)
	return mod_utils.get_division(angle, M.GROUND_MODES_DIV_TABLE)
end

-- Define sanic's local up and right vectors for his various ground modes
M.SANIC_GM_UP = {vmath.vector3(0,1,0), vmath.vector3(-1,0,0), vmath.vector3(0,-1,0), vmath.vector3(1,0,0)}
M.SANIC_GM_RIGHT = {vmath.vector3(1,0,0), vmath.vector3(0,1,0), vmath.vector3(-1,0,0), vmath.vector3(0,-1,0)}

M.BASE_ANGLE = {0.0, math.pi*0.5, math.pi, math.pi*1.5}
M.SWITCH_ANGLE = {math.rad(60), math.rad(30), math.rad(60), math.rad(30)}


function M.get_base_angle(ground_mode)
	return M.BASE_ANGLE[ground_mode]	
end


function M.get_switch_angle(ground_mode)
	return M.SWITCH_ANGLE[ground_mode]	
end


function M.wrap_ground_mode(ground_mode)
	return mod_utils.wrap(ground_mode, M.SANIC_GROUND_MODE_OVER, M.SANIC_GROUND_MODE_RIGHT)	
end



function M.separate_heightmap_coords(sub_tile_pos, ground_mode)
	if ground_mode == M.SANIC_GROUND_MODE_OVER then
		return {offset = sub_tile_pos.x, height = sub_tile_pos.y}
	elseif ground_mode == M.SANIC_GROUND_MODE_LEFT then
		return {offset = sub_tile_pos.y, height = mod_tile_helper.TILE_SIZE-sub_tile_pos.x}
	elseif ground_mode == M.SANIC_GROUND_MODE_UNDER then
		return {offset = sub_tile_pos.x, height = mod_tile_helper.TILE_SIZE-sub_tile_pos.y}
	elseif ground_mode == M.SANIC_GROUND_MODE_RIGHT then
		return {offset = sub_tile_pos.y, height = sub_tile_pos.x}
	else
		print(ground_mode)
		assert(nil, "Invalid ground mode!")
	end
end



return M