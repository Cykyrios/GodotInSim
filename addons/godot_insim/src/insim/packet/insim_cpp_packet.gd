class_name InSimCPPPacket
extends InSimPacket
## Cam Pos Pack packet - full camera packet (in car OR Shift+U mode)
##
## This packet is sent or received to update or read camera settings.

## Conversion factor between standard units and LFS-encoded values.
const POSITION_MULTIPLIER := 65536.0
## Conversion factor between standard units and LFS-encoded values.
const ANGLE_MULTIPLIER := 32768 / 180.0
## Conversion factor between standard units and LFS-encoded values.
const TIME_MULTIPLIER := 1000.0

const PACKET_SIZE := 32  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_CPP  ## The packet's type, see [enum InSim.Packet].
var zero := 0  ## Zero byte

var pos := Vector3i.ZERO  ## position vector

var heading := 0  ## heading - 0 points along Y axis
var pitch := 0  ## pitch
var roll := 0  ## roll

var view_plid := 255  ## unique ID of viewed player (0 = none)
var ingame_cam := 255  ## as reported in [InSimSTAPacket]

var fov := 70.0  ## 4-byte float: FOV in degrees

var time := 0  ## time in ms to get there (0 means instant)
var flags := 0  ## state flags (see [enum InSim.State])

var gis_position := Vector3.ZERO  ## Position in meters
var gis_angles := Vector3.ZERO  ## Angles in radians
var gis_time := 0.0  ## Time in seconds


## Creates and returns a new [InSimCPPPacket] from the given parameters.
static func create(
	cpp_pos: Vector3i, cpp_rot: Vector3i, cpp_plid: int, cpp_cam: int, cpp_fov: float,
	cpp_time := 0, cpp_flags := 0
) -> InSimCPPPacket:
	var packet := InSimCPPPacket.new()
	packet.pos = cpp_pos
	packet.heading = cpp_rot.z
	packet.pitch = cpp_rot.x
	packet.roll = cpp_rot.y
	packet.view_plid = cpp_plid
	packet.ingame_cam = cpp_cam
	packet.fov = cpp_fov
	packet.time = cpp_time
	packet.flags = cpp_flags
	packet.update_gis_values()
	return packet


## Creates and returns a new [InSimCPPPacket] from the given parameters, using standard units
## where applicable.
static func create_from_gis_values(
	cpp_pos: Vector3, cpp_rot: Vector3, cpp_plid: int, cpp_cam: int, cpp_fov: float,
	cpp_time := 0.0, cpp_flags := 0
) -> InSimCPPPacket:
	var packet := InSimCPPPacket.new()
	packet.gis_position = cpp_pos
	packet.gis_angles = cpp_rot
	packet.view_plid = cpp_plid
	packet.ingame_cam = cpp_cam
	packet.fov = cpp_fov
	packet.gis_time = cpp_time
	packet.flags = cpp_flags
	packet.set_values_from_gis()
	return packet


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	receivable = true
	sendable = true


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [get_type_string(), size, packet_size])
		return
	super(packet)
	zero = read_byte()
	pos.x = read_int()
	pos.y = read_int()
	pos.z = read_int()
	heading = read_word()
	pitch = read_word()
	roll = read_word()
	view_plid = read_byte()
	ingame_cam = read_byte()
	fov = read_float()
	time = read_word()
	flags = read_word()


func _fill_buffer() -> void:
	super()
	add_byte(zero)
	add_int(pos.x)
	add_int(pos.y)
	add_int(pos.z)
	add_word(heading)
	add_word(pitch)
	add_word(roll)
	add_byte(view_plid)
	add_byte(ingame_cam)
	add_float(fov)
	add_word(time)
	add_word(flags)


func _get_data_dictionary() -> Dictionary:
	return {
		"Pos": pos,
		"H": heading,
		"P": pitch,
		"R": roll,
		"ViewPLID": view_plid,
		"InGameCam": ingame_cam,
		"FOV": fov,
		"Time": time,
		"Flags": flags,
	}


func _get_pretty_text() -> String:
	return get_lfs_cam_command()


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(
		dict,
		["Pos", "H", "P", "R", "ViewPLID", "InGameCam", "FOV", "Time", "Flags"],
	):
		return
	pos = dict["Pos"]
	heading = dict["H"]
	pitch = dict["P"]
	roll = dict["R"]
	view_plid = dict["ViewPLID"]
	ingame_cam = dict["InGameCam"]
	fov = dict["FOV"]
	time = dict["Time"]
	flags = dict["Flags"]


func _update_gis_values() -> void:
	gis_position = Vector3(pos) / POSITION_MULTIPLIER
	gis_angles = Vector3(
		wrapf(deg_to_rad(-pitch / ANGLE_MULTIPLIER), -PI, PI),
		wrapf(deg_to_rad(roll / ANGLE_MULTIPLIER), -PI, PI),
		wrapf(deg_to_rad(heading / ANGLE_MULTIPLIER - 180), -PI, PI)
	)
	gis_time = time / TIME_MULTIPLIER


func _set_values_from_gis() -> void:
	pos.x = roundi(gis_position.x * POSITION_MULTIPLIER)
	pos.y = roundi(gis_position.y * POSITION_MULTIPLIER)
	pos.z = roundi(gis_position.z * POSITION_MULTIPLIER)
	pitch = wrapi(roundi(-rad_to_deg(gis_angles.x) * ANGLE_MULTIPLIER), 0, 65536)
	roll = wrapi(roundi(rad_to_deg(2 * PI - gis_angles.y) * ANGLE_MULTIPLIER), 0, 65536)
	heading = wrapi(roundi((180 + rad_to_deg(gis_angles.z)) * ANGLE_MULTIPLIER), 0, 65536)
	time = roundi(gis_time * TIME_MULTIPLIER)


## Returns the [code]/cp[/code] string corresponding to the current camera settings.
func get_lfs_cam_command() -> String:
	return "/cp %d %d %d %d %d %.1f %.1f" % [pos.x, pos.y, pos.z, heading, pitch, roll, fov]
