extends "builder/mesh_builder.gd"
	
func build_mesh(params, smooth = false, reverse = false):
	if params == 'default':
		params = [2,2,0,0]
		
	var l = params[0]    #Lenght
	var w = params[1]    #Width
	var sh = params[2]    #Start Height
	var eh = params[3]    #End Height
	
	var verts = []
	verts.append(Vector3(-w/2,eh,-l/2))
	verts.append(Vector3(w/2,eh,-l/2))
	verts.append(Vector3(w/2,sh,l/2))
	verts.append(Vector3(-w/2,sh,l/2))
	
	var uv = []
	uv.append(Vector2(1, 1))
	uv.append(Vector2(0, 1))
	uv.append(Vector2(0, 0))
	uv.append(Vector2(1, 0))
	
	begin(4)
	add_smooth_group(smooth)
	add_quad(verts, uv, reverse)
	generate_normals()
	
	var mesh = commit()
	clear()
	return mesh
	
func mesh_parameters(settings):
	add_tree_range(settings, "Length", 2, 0.1, 100, 0.1)
	add_tree_range(settings, "Width", 2, 0.1, 100, 0.1)
	add_tree_range(settings, "Start H.", 0, -100, 100, 0.1)
	add_tree_range(settings, "End H.", 0, -100, 100, 0.1)
