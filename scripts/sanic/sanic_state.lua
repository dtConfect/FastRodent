-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.

local M = {}

M.SANIC_STATE_GROUND = hash("ground")
M.SANIC_STATE_AIR = hash("air")

return M