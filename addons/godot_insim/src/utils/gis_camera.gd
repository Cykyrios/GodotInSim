class_name GISCamera
extends RefCounted
## GISCamera - Utility functions for camera manipulation and conversion
##
## This class provides utility functions to manipulate Godot cameras from LFS via [InSimCPPPacket]
## and [code]/cp[/code] strings, and to set LFS's camera from a Godot camera.[br]
## [br]
## [u][b]Important note:[/b][/u] LFS uses horizontal FoV in order to make multi-monitor setups
## easy to work with. Godot, on the other hand, defaults to vertical FoV; you can either switch
## cameras to [code]Keep Width[/code], and ignore the [code]aspect_ratio[/code] parameter in
## conversion functions (as long as your application window has the same aspect ratio as LFS),
## or keep the default [code]Keep Height[/code] and provide the aspect ratio.
## The expected use in both cases is to have the same aspect ratio on both LFS and Godot.[br]
## [br]
## [u][b]Note:[/b][/u] The functions in this class do not convert from the LFS coordinates
## (Y forward, Z up) to Godot coordinates (Y up, Z backward); if you want your scene to still
## have Y up, the easiest way to obtain the expected result is to have your entire scene
## parented to a [Node3D] rotated -90 degrees.

## Returns a [code]/cp[/code] string that can be pasted into LFS to set its camera,
## based on the passed [param camera]. [param aspect_ratio] is used to correct for horizontal fov
## vs vertical fov, and should match both your LFS resolution and your Godot application resolution
## in order to get a perfect match.
static func cp_string_from_camera(camera: Camera3D, aspect_ratio := 1.0) -> String:
	var position := Vector3i((camera.position * InSimCPPPacket.POSITION_MULTIPLIER).round())
	var angles := camera.basis.get_euler(EULER_ORDER_ZXY)
	return "/cp %d %d %d %d %d %.1f %.1f" % [
		position.x,
		position.y,
		position.z,
		roundi((rad_to_deg(angles.z) - 180) * InSimCPPPacket.ANGLE_MULTIPLIER),
		roundi((90 - rad_to_deg(angles.x)) * InSimCPPPacket.ANGLE_MULTIPLIER),
		rad_to_deg(angles.y),
		fov_camera_to_lfs(camera.fov, aspect_ratio)
	]


## Returns an [InSimCPPPacket] based on the passed [param camera]. The packet swtiches to Shift U
## free camera by default.
static func cpp_packet_from_camera(camera: Camera3D, aspect_ratio := 1.0) -> InSimCPPPacket:
	var angles := camera.basis.rotated(camera.basis.x, -PI / 2).get_euler(EULER_ORDER_ZXY)
	angles.y = -angles.y
	return InSimCPPPacket.create_from_gis_values(
		camera.position,
		angles,
		0,
		255,
		fov_camera_to_lfs(camera.fov, aspect_ratio),
		0,
		InSim.State.ISS_SHIFTU
	)


## Returns a [Camera3D] matching the parameters in the camera [param packet]. This is especially
## useful to interpolate your own camera to this one, e.g. using a [Tween].
static func get_camera_from_cpp_packet(packet: InSimCPPPacket, aspect_ratio := 1.0) -> Camera3D:
	var camera := Camera3D.new()
	camera.rotation_order = EULER_ORDER_ZXY
	camera.fov = fov_lfs_to_camera(packet.fov, aspect_ratio)
	var basis := Basis.from_euler(packet.gis_angles, EULER_ORDER_ZXY)
	basis = basis.rotated(basis.x, PI / 2)
	camera.transform = Transform3D(basis, packet.gis_position)
	return camera


## @experimental: May not work properly for normal cameras (not Shift+U)
## Sets the given [param camera]'s properties to match the received [param packet]. You can pass
## a [Vector3] [param plid_offset] to be used when the camera is placed relative to the
## corresponding car (for [constant InSim.State.ISS_SHIFTU_FOLLOW]; it has no effect
## on global coordinates). [param plid_offset] can be obtained from an [InSimMCIPacket] that you
## need to request separately.
static func set_camera_from_cpp_packet(
	camera: Camera3D, packet: InSimCPPPacket, plid_offset := Vector3.ZERO, aspect_ratio := 1.0
) -> void:
	var new_camera := get_camera_from_cpp_packet(packet, aspect_ratio)
	camera.fov = new_camera.fov
	var offset := plid_offset if (
		packet.flags & InSim.State.ISS_SHIFTU_FOLLOW
		or not packet.flags & InSim.State.ISS_SHIFTU
	) else Vector3.ZERO
	camera.transform = Transform3D(new_camera.basis, packet.gis_position + offset)


## Updates the given [param camera] to match the passed [param cp_string] (as obtained by typing
## [code]/cp[/code] in LFS). [param aspect_ratio] is used to correct for horizontal fov vs
## vertical fov, and should match both your LFS resolution and your Godot application resolution
## in order to get a perfect match.
static func set_camera_from_cp_string(
	camera: Camera3D, cp_string: String, aspect_ratio := 1.0
) -> void:
	var regex := RegEx.create_from_string(
		r"(?:/cp) (-?\d+) (-?\d+) (-?\d+) (-?\d+) (-?\d+) (-?\d+.?\d+) (-?\d+.?\d+)"
	)
	var result := regex.search(cp_string)
	if not result:
		return
	camera.position = Vector3(
		result.strings[1].to_int(),
		result.strings[2].to_int(),
		result.strings[3].to_int()
	) / InSimCPPPacket.POSITION_MULTIPLIER
	var angles := Vector3(
		deg_to_rad(90 - result.strings[5].to_int() / InSimCPPPacket.ANGLE_MULTIPLIER),
		deg_to_rad(result.strings[6].to_float()),
		deg_to_rad(wrapf(
			180 + result.strings[4].to_int() / InSimCPPPacket.ANGLE_MULTIPLIER, -180, 180
		))
	)
	camera.rotation_order = EULER_ORDER_ZXY
	camera.basis = Basis.from_euler(angles, EULER_ORDER_ZXY)
	camera.fov = fov_lfs_to_camera(result.strings[7].to_float(), aspect_ratio)


## Converts the given [param fov] to LFS format. In order to get a perfect match,
## [param aspect_ratio] should be the same in both LFS and your application.
static func fov_camera_to_lfs(fov: float, aspect_ratio: float) -> float:
	return 2 * rad_to_deg(atan(tan(deg_to_rad(fov) / 2) * aspect_ratio))


## Converts the given [param fov] to Godot format. In order to get a perfect match,
## [param aspect_ratio] should be the same in both LFS and your application.
static func fov_lfs_to_camera(fov: float, aspect_ratio: float) -> float:
	return 2 * rad_to_deg(atan(tan(deg_to_rad(fov) / 2.0) / aspect_ratio))
