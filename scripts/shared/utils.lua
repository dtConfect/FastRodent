-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.

local M = {}

function M.print_table(table)
	for key, value in pairs(table) do
		print('\t', key, value)
	end
end

function M.sign(number)
	if number >= 0 then
		return 1
	else
		return -1
	end	
end

function M.scale_vector(vector, scale_vector)
	return vmath.vector3(vector.x*scale_vector.x, vector.y*scale_vector.y, vector.z*scale_vector.z)	
end

return M