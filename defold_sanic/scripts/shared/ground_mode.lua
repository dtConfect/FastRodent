-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.

local mod_tile_helper = require "scripts.shared.tile_helper"

local M = {}

-- Define sanic's ground modes
M.SANIC_GROUND_MODE_OVER = 1
M.SANIC_GROUND_MODE_LEFT = 2
M.SANIC_GROUND_MODE_UNDER = 3
M.SANIC_GROUND_MODE_RIGHT = 4

M.SANIC_GROUND_MODES = 4

-- Define sanic's local up and right vectors for his various ground modes
M.SANIC_GM_UP = {vmath.vector3(0,1,0), vmath.vector3(-1,0,0), vmath.vector3(0,-1,0), vmath.vector3(1,0,0)}
M.SANIC_GM_RIGHT = {vmath.vector3(1,0,0), vmath.vector3(0,1,0), vmath.vector3(-1,0,0), vmath.vector3(0,-1,0)}

function M.separate_heightmap_coords(sub_tile_pos, ground_mode)
	if ground_mode == M.SANIC_GROUND_MODE_OVER then
		return {offset = sub_tile_pos.x, height = sub_tile_pos.y}
	elseif ground_mode == M.SANIC_GROUND_MODE_LEFT then
		return {offset = sub_tile_pos.y, height = mod_tile_helper.TILE_SIZE-sub_tile_pos.x}
	elseif ground_mode == M_SANIC_GROUND_MODE_UNDER then
		return {offset = sub_tile_pos.x, height = mod_tile_helper.TILE_SIZE-sub_tile_pos.y}
	elseif ground_mode == M.SANIC_GROUND_MODE_RIGHT then
		return {offset = sub_tile_pos.y, height = sub_tile_pos.x}
	else
		assert(nil, "Invalid ground mode!")	
	end
end

return M