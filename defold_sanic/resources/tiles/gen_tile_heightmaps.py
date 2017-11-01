import json
import math
from PIL import Image
from copy import deepcopy

WHITE = (255, 255, 255)

def colour_matches(colour_a, colour_b):
	
	return (colour_a[0] == colour_b[0] and colour_a[1] == colour_b[1] and colour_a[2] == colour_b[2])

	
# Convert the angle to radians - it's easier to define degrees in data
def process_angle(angle):
	a = (angle/360)*(math.pi*2.0)
	return a

	
def process_angles(angles):
	outangles = []
	for a in angles:
		outangles.append(process_angle(a))

	return outangles
	
	

def get_low_and_high_pixels(img, height, x):
	low = -1
	high = -1
	
	for i in range(0, height):
		# PILLOW orders pixels top to bottom, so we'll need to flip our y ordering
		y = height-i-1
		if colour_matches(img.getpixel((x,y)), WHITE) == False:
			if low<0:
				low = i
			high = i
	
	return low, high



def get_left_and_right_pixels(img, width, y):
	left = -1
	right = -1
	
	for x in range(0, width):
		if colour_matches(img.getpixel((x,y)), WHITE) == False:
			if left<0:
				left = x
			right = x
	
	return left, right


	
def pixel_to_heightmap(v, sub=None):
	if v >= 0:
		if sub:
			v = sub-v
	
		# Add 1 to a valid pixel position to make it a height value
		return v+1
	else:
		# For invalid pixel positions return 0 (no height)
		return 0
	
	

def process_tile(img, data):
	OVER_INDEX = 0
	LEFT_INDEX = 1
	UNDER_INDEX = 2
	RIGHT_INDEX = 3
	
	if data == None:
		outdata = {"angle" : 0}
	else:
		outdata = deepcopy(data)
		outdata["angle"] = process_angle(outdata["angle"])
	
	outdata["heightmap"] = [[],[],[],[]]
	outdata["solid"] = False
	
	# Note: Heightmaps are ordered left to right, bottom to top, for each horizontal or vertical face.
	# Generate heightmaps for over and under
	for x in range(0,img.size[0]):
		l, h = get_low_and_high_pixels(img, img.size[1], x)
		
		# Convert low and high to heightmap values
		l = pixel_to_heightmap(l, sub=img.size[1]-1)
		h = pixel_to_heightmap(h)
		
		if l>0 or h>0:
			outdata["solid"] = True
		
		outdata["heightmap"][OVER_INDEX].append(h)
		outdata["heightmap"][UNDER_INDEX].append(l)
	
	# Generate heightmaps for left and right
	for i in range(0,img.size[1]):
		# PILLOW orders pixels top to bottom, so we'll need to flip our y ordering
		y = img.size[1]-i-1
		
		l, r = get_left_and_right_pixels(img, img.size[0], y)
	
		# Convert left and right to heightmap values
		l = pixel_to_heightmap(l, sub=img.size[0]-1)
		r = pixel_to_heightmap(r)
	
		if l>0 or r>0:
			outdata["solid"] = True
		
		outdata["heightmap"][LEFT_INDEX].append(l)
		outdata["heightmap"][RIGHT_INDEX].append(r)
		
	return outdata
	

	
if __name__ == "__main__":
	INPUT_DATA_FILE_NAME = "tile_height.json"
	OUTPUT_FILE_NAME = "gen_tile_black.json"
	
	
	
	# initialise variable for json data
	outdata = {"params":{},"tile_data":{}}
	
	
	
	# Load tile data
	try:
		data_file = open(INPUT_DATA_FILE_NAME, 'r')
	except:
		print("Failed to read data file, %s" % INPUT_DATA_FILE_NAME)
	
	indata = json.load(data_file)

	data_file.close()
	
	TILE_WIDTH = indata["params"]["width"]
	TILE_HEIGHT = indata["params"]["height"]
	
	TILE_MARGIN = indata["params"]["margin"]
	TILE_SPACING = indata["params"]["spacing"]
	
	# Yes, margin is in the below twice by design
	TILE_WIDTH_WITH_SPACING = TILE_MARGIN + TILE_WIDTH + TILE_MARGIN + TILE_SPACING
	TILE_HEIGHT_WITH_SPACING = TILE_MARGIN + TILE_HEIGHT + TILE_MARGIN + TILE_SPACING
	
	
	# Load tile img
	img_file_name = indata["params"]["height_img"]
	try:
		img_file = Image.open(img_file_name)
	except:
		print("Failed to read img file, %s" % img_file_name) 
	
	
	# Copy params
	outdata["params"] = indata["params"]
	
	# Process image and data
	print("processing", img_file.format, "%dx%d" % img_file.size, img_file.mode)
			
	img_width = img_file.size[0]
	img_height = img_file.size[1]
	xcount = math.floor(img_width / TILE_WIDTH_WITH_SPACING)
	ycount = math.floor(img_height / TILE_HEIGHT_WITH_SPACING)
	total_tiles = xcount * ycount
	
	i = 1
	for y in range(0,xcount):
		for x in range(0, ycount):
			# Get region coordinates for a single tile
			x_margin_start = TILE_WIDTH_WITH_SPACING * x
			y_margin_start = TILE_HEIGHT_WITH_SPACING * y
			
			x_start = x_margin_start + TILE_MARGIN
			y_start = y_margin_start + TILE_MARGIN
			
			x_end = x_start + TILE_WIDTH
			y_end = y_start + TILE_HEIGHT
	
			box = (x_start, y_start, x_end, y_end)
			tile_region = img_file.crop(box)
			
			try:
				tile_data = indata["tile_data"][str(y)][str(x)]
			except:
				tile_data = None
			outdata["tile_data"][str(i)] = process_tile(tile_region, tile_data)
			i += 1
	
	
	# Close img file
	img_file.close()
	
	# Write out resultant json data
	with open(OUTPUT_FILE_NAME, 'w') as outfile:
		json.dump(outdata, outfile,indent=4)
		#json.dump(outdata, outfile)
		




