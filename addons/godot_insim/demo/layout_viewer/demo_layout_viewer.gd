extends Node3D

## This demo shows loading an SMX environment and a layout to display together, with the camera
## synchronized from LFS (in Shift+U view, normal views can follow cars but won't rotate properly).
## [br]Additionally, any change in the layout from LFS will be reflected in the scene.

## Update this to point to the downloaded LFS_SMX directory (available at
## [url]https://www.lfs.net/programmer[/url])
@export var track_dir := "C:/LFS/LFS_SMX_6H"
## Update this to point to the LFS layout directory ([code]C:/LFS/data/layout[/code] by default)
@export var layout_dir := "C:/LFS/data/layout"
var custom_smx_dir := "res://addons/godot_insim/assets/smx"
var track_name := ""
var layout_name := ""

var insim: InSim = null

var track_file: SMXFile = null
var layout_file: LYTFile = null

## The [Vector4] contains x, y, z and heading information
var mci_data: Dictionary[int, Vector4] = {}
var cam_tween: Tween = null

var req_i := 42  ## Custom ReqI for this demo program

@onready var camera: Camera3D = %Camera3D
@onready var track: Node3D = %Track
@onready var layout: Node3D = %Layout


func _ready() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	camera.rotation_order = EULER_ORDER_ZXY
	await get_tree().process_frame
	insim = InSim.new()
	add_child(insim)
	insim.initialize("127.0.0.1", 29_999, InSimInitializationData.create(
		"Layout Viewer",
		"",
		InSim.InitFlag.ISF_LOCAL | InSim.InitFlag.ISF_AXM_EDIT,
		""
	))
	var _connect := insim.isp_axi_received.connect(_on_axi_packet_received)
	_connect = insim.isp_axm_received.connect(_on_axm_packet_received)
	_connect = insim.isp_cpp_received.connect(_on_cpp_packet_received)
	_connect = insim.isp_mci_received.connect(_on_mci_packet_received)
	_connect = insim.isp_sta_received.connect(_on_sta_packet_received)
	_connect = insim.tiny_axc_received.connect(_on_tiny_axc_received)
	var timer := Timer.new()
	add_child(timer)
	_connect = timer.timeout.connect(func() -> void:
		if not insim.insim_connected:
			return
		insim.send_packet(InSimTinyPacket.create(req_i, InSim.Tiny.TINY_SCP))
		insim.send_packet(InSimTinyPacket.create(req_i, InSim.Tiny.TINY_MCI))
	)
	timer.start(0.1)
	await get_tree().create_timer(0.5).timeout
	insim.send_packet(InSimTinyPacket.create(req_i, InSim.Tiny.TINY_AXI))


func clear_layout() -> void:
	for child in layout.get_children():
		child.queue_free()


func clear_track() -> void:
	for child in track.get_children():
		child.queue_free()


func display_layout() -> void:
	if not layout_file:
		return
	clear_layout()
	for object in layout_file.objects:
		var mesh := object.get_mesh()
		mesh.position = object.gis_position
		mesh.rotation.z = object.gis_heading
		if not mesh.mesh.surface_get_material(0):
			mesh.material_override = object.generate_default_material()
			(mesh.material_override as StandardMaterial3D).albedo_color = Color.WEB_GRAY
		layout.add_child(mesh)
		# Ground check
		if object.index == InSim.AXOIndex.AXO_CHALK_LINE2:
			pass
		if (
			not (object.flags & 0x80)  # not floating
			and (
				object.index < InSim.AXOIndex.AXO_CONCRETE_SLAB
				or object.index > InSim.AXOIndex.AXO_CONCRETE_WEDGE
			)
		):
			track_file.place_object_on_ground(mesh, object)


func display_track() -> void:
	if not track_file:
		return
	clear_track()
	track.add_child(track_file.get_mesh())


func _on_axi_packet_received(packet: InSimAXIPacket) -> void:
	layout_file = LYTFile.load_from_file("%s.lyt" % [layout_dir.path_join(packet.layout_name)])
	display_layout()


func _on_axm_packet_received(packet: InSimAXMPacket) -> void:
	if packet.pmo_action == InSim.PMOAction.PMO_ADD_OBJECTS:
		for object_info in packet.info:
			var object := LYTFile.create_object_from_buffer(object_info.get_buffer())
			var object_mesh := object.get_mesh()
			object_mesh.position = object.gis_position
			object_mesh.rotation.z = object.gis_heading
			layout.add_child(object_mesh)
	elif packet.pmo_action == InSim.PMOAction.PMO_DEL_OBJECTS:
		for object_info in packet.info:
			for child: MeshInstance3D in layout.get_children():
				if child.position.is_equal_approx(object_info.gis_position):
					child.queue_free()


func _on_cpp_packet_received(packet: InSimCPPPacket) -> void:
	var offset := Vector3.ZERO
	var heading := 0.0
	if (
		(packet.flags & InSim.State.ISS_SHIFTU_FOLLOW or not packet.flags & InSim.State.ISS_SHIFTU)
		and mci_data.has(packet.view_plid)
	):
		var mci := mci_data[packet.view_plid]
		offset = Vector3(mci.x, mci.y, mci.z)
		heading = mci.w
		if not packet.flags & InSim.State.ISS_SHIFTU:
			offset += Vector3(0, -5, 1).rotated(Vector3(0, 0, 1), -heading)
	# Use a temporary camera as interpolation target, to prevent choppy updates. This also helps
	# prevent rotation issues by interpolating the camera orientation as a quaternion instead of
	# Euler angles.
	var temp_cam := GISCamera.get_camera_from_cpp_packet(packet)
	temp_cam.position += offset
	if cam_tween:
		cam_tween.kill()
	cam_tween = create_tween().set_parallel()
	var duration := 0.15
	var _tween := cam_tween.tween_property(camera, "fov", temp_cam.fov, duration)
	_tween = cam_tween.tween_property(camera, "position", temp_cam.position, duration)
	_tween = cam_tween.tween_property(camera, "quaternion", temp_cam.quaternion, duration)


func _on_mci_packet_received(packet: InSimMCIPacket) -> void:
	for data in packet.info:
		mci_data[data.plid] = Vector4(
			data.gis_position.x,
			data.gis_position.y,
			data.gis_position.z,
			data.gis_heading
		)


func _on_sta_packet_received(packet: InSimSTAPacket) -> void:
	var sta_track := packet.track.substr(0, 2)
	track_name = ""
	match sta_track:
		"BL":
			track_name = "Blackwood"
		"SO":
			track_name = "South City"
		"FE":
			track_name = "Fern Bay"
		"AU":
			track_name = "Autocross"
		"KY":
			track_name = "Kyoto Ring"
		"WE":
			track_name = "Westhill"
		"AS":
			track_name = "Aston"
		"LA":
			track_name = "Layout Square"
	if (
		track.get_child_count() >= 1 and track.get_child(0).name == track_name
		or track_name.is_empty()
	):
		return
	var path := "%s_3DH.smx" % [track_dir.path_join(track_name)]
	if not FileAccess.file_exists(path):
		path = path.replace(path.get_base_dir(), custom_smx_dir)
		if not FileAccess.file_exists(path):
			push_error("Could not find track environment file at %s" % [path])
			return
	track_file = SMXFile.load_from_file(path)
	track_file.update_triangle_mesh()
	display_track()


func _on_tiny_axc_received(_packet: InSimTinyPacket) -> void:
	for child in layout.get_children():
		child.queue_free()
