@tool
extends EditorScenePostImport


func _post_import(scene: Node) -> Object:
	var smx := SMXFile.new()
	smx.lfssmx = "LFSSMX"
	smx.game_version = 0
	smx.game_revision = 0
	smx.smx_version = 0
	smx.dimensions = 3
	smx.resolution = 0
	smx.vertex_colors = 1
	smx.track = scene.name
	smx.ground_color_red = 46
	smx.ground_color_green = 45
	smx.ground_color_blue = 47
	for mesh_instance: MeshInstance3D in scene.get_children():
		var object := SMXObject.new()
		object.centre = mesh_instance.position
		var mesh := mesh_instance.mesh
		var p := 0
		for s in mesh.get_surface_count():
			var surface := mesh.surface_get_arrays(s)
			var mat := mesh.surface_get_material(s) as StandardMaterial3D
			var vertices := surface[Mesh.ARRAY_VERTEX] as PackedVector3Array
			var indices := surface[Mesh.ARRAY_INDEX] as PackedInt32Array
			for i in indices.size():
				var point := SMXPoint.new()
				point.position = mesh_instance.transform * vertices[indices[i]]
				point.color = mat.albedo_color
				object.points.append(point)
				if i % 3 == 2:
					var triangle := SMXTriangle.new()
					triangle.vertex_a = p - 2
					triangle.vertex_b = p
					triangle.vertex_c = p - 1
					object.triangles.append(triangle)
				p += 1
		object.num_points = object.points.size()
		object.num_tris = object.triangles.size()
		smx.objects.append(object)
	smx.num_objects = smx.objects.size()
	smx.save_to_file("%s/%s.smx" % [get_source_file().get_base_dir(), smx.track])
	return scene
