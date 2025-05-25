class_name PTHFile
extends LFSPacket
## PTH File
##
## This class can read PTH files and extract the [PTHNode]s contained in it. It also provides
## utility functions such as 3D mesh creation based on the [member nodes].

## Header, always equal to LFSPTH.
var lfspth := ""
## File format version.
var version := 0
## File format revision.
var revision := 0
## Number of nodes in this path.
var num_nodes := 0
## The node corresponding (approximately) to the finish line.
var finish_line := 0
## The list of nodes in the path.
var nodes: Array[PTHNode] = []


## Creates and returns a [PTHFile] parsed from [param path]. If the file cannot be read, an empty
## [PTHFile] is returned. If the header is invalid, [member nodes] will be empty.
static func load_from_file(path: String) -> PTHFile:
	var file := FileAccess.open(path, FileAccess.READ)
	var error := FileAccess.get_open_error()
	if error != OK:
		push_error("Error code %d occurred while opening file at %s" % [error, path])
		return PTHFile.new()
	var pth_file := PTHFile.new()
	pth_file.buffer = file.get_buffer(file.get_length())
	pth_file.lfspth = pth_file.read_string(6)
	pth_file.version = pth_file.read_byte()
	pth_file.revision = pth_file.read_byte()
	if pth_file.lfspth != "LFSPTH":
		push_warning("LFSPTH: Wrong file type.")
		return pth_file
	if pth_file.version > 0 or pth_file.revision > 0:
		push_warning("PTH Version/Revision is not supported.")
		return pth_file
	pth_file.num_nodes = pth_file.read_int()
	pth_file.finish_line = pth_file.read_int()
	pth_file.nodes.clear()
	for i in pth_file.num_nodes:
		pth_file.nodes.append(PTHNode.create_from_buffer(pth_file.read_buffer(40)))
	return pth_file


## Returns a [Node2D] with 2 [Polygon2D] and a [Line2D] children containing the polygons built
## from connecting the [PTHNode]s in the file. The polygons represent the "outer limits" and the
## "road limits", while the line follows the center nodes.
## If [member nodes] is empty, returns empty mesh instances.
func get_2d_mesh() -> Node2D:
	var pth_mesh := Node2D.new()
	for i in 2:
		var polygon := Polygon2D.new()
		polygon.antialiased = true
		polygon.color = Color.WHITE if i == 0 else Color.DIM_GRAY
		var points := PackedVector2Array()
		for n in nodes.size() + 1:
			var node := nodes[n - 1]
			var drive := node.center + node.xform.basis.x * node.drive_left
			var limit := node.center + node.xform.basis.x * node.limit_left
			var _discard := points.push_back(
				Vector2(drive.x, -drive.y) if i == 0 else Vector2(limit.x, -limit.y)
			)
		for n in nodes.size() + 1:
			var node := nodes[-n]
			var drive := node.center + node.xform.basis.x * node.drive_right
			var limit := node.center + node.xform.basis.x * node.limit_right
			var _discard := points.push_back(
				Vector2(drive.x, -drive.y) if i == 0 else Vector2(limit.x, -limit.y)
			)
		polygon.polygon = points
		pth_mesh.add_child(polygon)
	pth_mesh.move_child(pth_mesh.get_child(1), 0)
	var line := Line2D.new()
	line.closed = true
	line.width = 2
	line.default_color = Color.RED
	line.antialiased = true
	for node in nodes:
		line.add_point(Vector2(node.center.x, -node.center.y))
	pth_mesh.add_child(line)
	return pth_mesh


## Returns a [Node3D] with 3 [MeshInstance3D] children containing the meshes built from connecting
## the [PTHNode]s in the file. The first mesh is a line following the center nodes.
## The following triangle-based meshes represent the "road limits" and the "outer limits".
## If [member nodes] is empty, returns empty mesh instances.
func get_3d_mesh() -> Node3D:
	var pth_mesh := Node3D.new()
	for i in 3:
		var mesh_instance := MeshInstance3D.new()
		var mesh := ArrayMesh.new()
		mesh_instance.mesh = mesh
		var arrays: Array = []
		var _discard := arrays.resize(Mesh.ARRAY_MAX)
		var vertices := PackedVector3Array()
		for n in nodes.size():
			var node_1 := nodes[n - 1]
			var node_2 := nodes[n]
			var center_1 := node_1.center
			var center_2 := node_2.center
			var drive_left_1 := center_1 + node_1.xform.basis.x * node_1.drive_left
			var drive_left_2 := center_2 + node_2.xform.basis.x * node_2.drive_left
			var drive_right_1 := center_1 + node_1.xform.basis.x * node_1.drive_right
			var drive_right_2 := center_2 + node_2.xform.basis.x * node_2.drive_right
			var limit_left_1 := center_1 + node_1.xform.basis.x * node_1.limit_left
			var limit_left_2 := center_2 + node_2.xform.basis.x * node_2.limit_left
			var limit_right_1 := center_1 + node_1.xform.basis.x * node_1.limit_right
			var limit_right_2 := center_2 + node_2.xform.basis.x * node_2.limit_right
			if i == 0:
				_discard = vertices.push_back(center_1)
				_discard = vertices.push_back(center_2)
			else:
				_discard = vertices.push_back(drive_left_1 if i == 1 else limit_left_1)
				_discard = vertices.push_back(drive_left_2 if i == 1 else limit_left_2)
				_discard = vertices.push_back(drive_right_1 if i == 1 else limit_right_1)
				_discard = vertices.push_back(drive_left_2 if i == 1 else limit_left_2)
				_discard = vertices.push_back(drive_right_2 if i == 1 else limit_right_2)
				_discard = vertices.push_back(drive_right_1 if i == 1 else limit_right_1)
		if not vertices.is_empty():
			arrays[Mesh.ARRAY_VERTEX] = vertices
			mesh.add_surface_from_arrays(
				Mesh.PRIMITIVE_LINES if i == 0 else Mesh.PRIMITIVE_TRIANGLES,
				arrays
			)
			var mat := StandardMaterial3D.new()
			mat.albedo_color = Color.WHITE
			mesh.surface_set_material(mesh.get_surface_count() - 1, mat)
		pth_mesh.add_child(mesh_instance)
	return pth_mesh


## Updates the colors of the polygons and the line's color and width. You must pass
## [param pth_mesh] as obtained from [method get_2d_mesh].
func update_2d_mesh(
	pth_mesh: Node2D, line_width := 2.0, line_color := Color.RED, road_color := Color.WHITE,
	limits_color := Color.DIM_GRAY
) -> void:
	if (
		pth_mesh.get_child_count() != 3
		or pth_mesh.get_child(0) is not Polygon2D
		or pth_mesh.get_child(1) is not Polygon2D
		or pth_mesh.get_child(2) is not Line2D
	):
		push_warning("Unexpected input mesh, see PTHFile.get_2d_mesh()")
		return
	var line := pth_mesh.get_child(2) as Line2D
	line.width = line_width
	line.default_color = line_color
	(pth_mesh.get_child(0) as Polygon2D).color = limits_color
	(pth_mesh.get_child(1) as Polygon2D).color = road_color


## Updates the colors of the 3 meshes making the PTH mesh. You must pass [param pth_mesh]
## as obtained from [method get_3d_mesh].
func update_3d_mesh(
	pth_mesh: Node3D, line_color := Color.RED, road_color := Color.WHITE,
	limits_color := Color.DIM_GRAY
) -> Node3D:
	if (
		pth_mesh.get_children().any(func(child: Node) -> bool: return child is not MeshInstance3D)
		or pth_mesh.get_child_count() != 3
	):
		push_warning("Unexpected input mesh, see PTHFile.get_3d_mesh()")
		return pth_mesh
	var mesh_line := pth_mesh.get_child(0) as MeshInstance3D
	(mesh_line.mesh.surface_get_material(0) as StandardMaterial3D) \
			.albedo_color = line_color
	var mesh_road := pth_mesh.get_child(1) as MeshInstance3D
	(mesh_road.mesh.surface_get_material(0) as StandardMaterial3D) \
			.albedo_color = road_color
	var mesh_limits := pth_mesh.get_child(2) as MeshInstance3D
	(mesh_limits.mesh.surface_get_material(0) as StandardMaterial3D) \
			.albedo_color = limits_color
	return pth_mesh
