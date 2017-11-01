-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.

local mod_utils = {}

function mod_utils.print_table(table)
	for key, value in pairs(table) do
		print('\t', key, value)
	end
end

function mod_utils.sign(number)
	if number >= 0 then
		return 1
	else
		return -1
	end	
end

function mod_utils.wrap(number, min, max)
	local upper_bound = max+1
	local range = upper_bound-min
	local ret = ((number-min) % range)
	if ret < 0 then
		return upper_bound + 1 + number
	else
		return min + ret	
	end
end

function mod_utils.scale_vector(vector, scale_vector)
	return vmath.vector3(vector.x*scale_vector.x, vector.y*scale_vector.y, vector.z*scale_vector.z)	
end

function mod_utils.fwrap_max(number, max)
	return math.fmod(max + math.fmod(number, max), max)
end

function mod_utils.fwrap(number, min, max)
	return min + mod_utils.fwrap_max(number - min, max - min)
end

function mod_utils.fwrap_positive_rad(rad)
	return mod_utils.fwrap(rad, 0, math.pi*2.0)	
end

function mod_utils.fwrap_half_rot_rad(rad)
	return mod_utils.fwrap(rad, -math.pi, math.pi)
end


-- Helper functions for transforming rotational values based upon a set number of divisions
function mod_utils.create_division_table(divisions)
	local div_table = {}
	div_table.divisions = divisions
	div_table.div_2_rad = (2*math.pi)/div_table.divisions
	div_table.rad_2_div = div_table.divisions/(2*math.pi)
	return div_table
end


-- Returns the positive or negative integer corresponding to the nearest equal rotational division
function mod_utils.get_division_angle_for_angle(angle, div_table)
	local offset_angle = angle +(div_table.div_2_rad*0.5)
	return math.floor(div_table.rad_2_div * offset_angle)
end


-- Returns the angle reduced to the nearest equal rotational division based
function mod_utils.get_division_aligned_angle_for_angle(angle, div_table)
	return div_table.div_2_rad * mod_utils.get_division_angle_for_angle(angle, div_table)
end



function mod_utils.get_division(angle, div_table)
	return mod_utils.wrap(mod_utils.get_division_angle_for_angle(angle, div_table) +1, 1, div_table.divisions)
end




return mod_utils