extends Node3D

## This demo shows loading an SMX environment and a layout to display together, with the camera
## synchronized from LFS (in Shift+U view, normal views can follow cars but won't rotate properly).
## [br]You should change the project settings to enable per-pixel window transparency
## ([code]display/window/per_pixel_transparency/allowed[/code]) as well as transparent viewport
## background ([code]rendering/viewport/transparent_background[/code]), so you can overlay the
## window on top of LFS.

## Update this to point to the LFS SMX directory ([code]C:/LFS/data/smx[/code] by default)
@export var smx_dir := "C:/LFS/data/smx"
var pth_name := ""

var insim: InSim = null

var pth_file: PTHFile = null

## The [Vector4] contains x, y, z and heading information
var mci_data: Dictionary[int, Vector4] = {}
var cam_tween: Tween = null

var req_i := 42  ## Custom ReqI for this demo program

@onready var camera: Camera3D = %Camera3D
@onready var pth: Node3D = %PTH


func _ready() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	camera.rotation_order = EULER_ORDER_ZXY
	await get_tree().process_frame
	insim = InSim.new()
	add_child(insim)
	insim.initialize("127.0.0.1", 29_999, InSimInitializationData.create(
		"PTH Viewer",
		InSim.InitFlag.ISF_LOCAL,
	))
	var _connect := insim.isp_cpp_received.connect(_on_cpp_packet_received)
	_connect = insim.isp_mci_received.connect(_on_mci_packet_received)
	_connect = insim.isp_sta_received.connect(_on_sta_packet_received)
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
	insim.send_packet(InSimTinyPacket.create(req_i, InSim.Tiny.TINY_SST))


func clear_pth() -> void:
	for child in pth.get_children():
		child.queue_free()


func display_pth() -> void:
	if not pth_file:
		return
	clear_pth()
	var pth_mesh := pth_file.get_3d_mesh()
	pth_mesh = pth_file.update_3d_mesh(pth_mesh, Color.GREEN, Color.RED, Color.DARK_GOLDENROD)
	(pth_mesh.get_child(2) as Node3D).translate(Vector3(0, 0, -0.1))
	(pth_mesh.get_child(0) as Node3D).translate(Vector3(0, 0, 0.1))
	for child: MeshInstance3D in pth_mesh.get_children():
		var mat := child.mesh.surface_get_material(0) as StandardMaterial3D
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		mat.albedo_color.a = 0.25
	pth.add_child(pth_mesh)


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
	pth_name = packet.track
	var path := "%s.pth" % [smx_dir.path_join(pth_name)]
	if not FileAccess.file_exists(path):
		push_error("Could not find PTH file at %s" % [path])
		return
	pth_file = PTHFile.load_from_file(path)
	display_pth()
