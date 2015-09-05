extends 'builder/MeshBuilder.gd'

var radius = 1.0
var segments = 16
var height_segments = 8
var hemisphere = 0.0
var generate_cap = true

static func get_name():
	return "Sphere"
	
func set_parameter(name, value):
	if name == 'radius':
		radius = value
		
	elif name == 'segments':
		segments = value
		
	elif name == 'height_segments':
		height_segments = value
		
	elif name == 'hemisphere':
		hemisphere = value
		
	elif name == 'generate_cap':
		generate_cap = value
		
func create(smooth, invert):
	var circle = build_circle_verts(Vector3(), segments, radius)
	
	var h_val = 1.0 - hemisphere
	
	var angle = PI * h_val / height_segments
	
	var pos = Vector3(0, -cos(angle) * radius, 0)
	var rd = Vector3(sin(angle), 0, sin(angle))
	
	begin(VS.PRIMITIVE_TRIANGLES)
	
	set_invert(invert)
	
	if hemisphere > 0.0:
		pos.y = cos(angle * height_segments) * radius
		rd.x = sin(angle * height_segments)
		rd.z = rd.x
		
		if generate_cap:
			add_smooth_group(false)
			
			for idx in range(segments):
				add_tri([pos, circle[idx+1] * rd + pos, circle[idx] * rd + pos])
				
		add_smooth_group(smooth)
		
	else:
		add_smooth_group(smooth)
		
		for idx in range(segments):
			add_tri([Vector3(0, -radius, 0), circle[idx+1] * rd + pos, circle[idx] * rd + pos])
			
	for i in range(height_segments, 1, -1):
		var n = i - 1
		
		var next_pos = Vector3(0, cos(angle * n) * radius, 0)
		var next_radius = Vector3(sin(angle * n), 0, sin(angle * n))
		
		for idx in range(segments):
			add_quad([circle[idx+1] * rd + pos,
			          circle[idx+1] * next_radius + next_pos,
			          circle[idx] * next_radius + next_pos,
			          circle[idx] * rd + pos])
			
		pos = next_pos
		rd = next_radius
		
	pos = Vector3(0, cos(angle) * radius, 0)
	
	for idx in range(segments):
		add_tri([circle[idx] * rd + pos, circle[idx+1] * rd + pos, Vector3(0, radius, 0)])
		
	var mesh = commit()
	
	return mesh
	
func mesh_parameters(tree):
	add_tree_range(tree, 'Radius', radius)
	add_tree_range(tree, 'Segments', segments, 1, 3, 64)
	add_tree_range(tree, 'Height Segments', height_segments, 1, 3, 64)
	add_tree_range(tree, 'Hemisphere', hemisphere, 0.01, 0, 0.99)
	add_tree_empty(tree)
	add_tree_check(tree, 'Generate Cap', generate_cap)

