class_name InSimCPPPacket
extends InSimPacket

## Cam Pos Pack packet - full camera packet (in car OR Shift+U mode)

const POSITION_MULTIPLIER := 65536.0
const ANGLE_MULTIPLIER := 32768 / 180.0
const TIME_MULTIPLIER := 1000.0

const PACKET_SIZE := 32
const PACKET_TYPE := InSim.Packet.ISP_CPP
var zero := 0

var pos := Vector3i.ZERO  ## position vector

var heading := 0  ## heading - 0 points along Y axis
var pitch := 0  ## pitch
var roll := 0  ## roll

var view_plid := 255  ## unique ID of viewed player (0 = none)
var ingame_cam := 255  ## as reported in [InSimSTAPacket]

var fov := 70.0  ## 4-byte float: FOV in degrees

var time := 0  ## time in ms to get there (0 means instant)
var flags := 0  ## state flags (see [enum InSim.State])

var gis_position := Vector3.ZERO
var gis_angles := Vector3.ZERO
var gis_time := 0.0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	receivable = true
	sendable = true


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
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
		"Zero": zero,
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


func _update_gis_values() -> void:
	gis_position = Vector3(pos) / POSITION_MULTIPLIER
	gis_angles = Vector3(
		wrapf(deg_to_rad(-pitch / ANGLE_MULTIPLIER), -PI, PI),
		wrapf(deg_to_rad(roll / ANGLE_MULTIPLIER), -PI, PI),
		wrapf(deg_to_rad(heading / ANGLE_MULTIPLIER - 180), -PI, PI)
	)
	gis_time = time / TIME_MULTIPLIER


func _set_values_from_gis() -> void:
	pos.x = int(gis_position.x * POSITION_MULTIPLIER)
	pos.y = int(gis_position.y * POSITION_MULTIPLIER)
	pos.z = int(gis_position.z * POSITION_MULTIPLIER)
	pitch = wrapi(-rad_to_deg(gis_angles.x) * ANGLE_MULTIPLIER, 0, 65536)
	roll = wrapi(rad_to_deg(2 * PI - gis_angles.y) * ANGLE_MULTIPLIER, 0, 65536)
	heading = wrapi((180 + rad_to_deg(gis_angles.z)) * ANGLE_MULTIPLIER, 0, 65536)
	time = gis_time * TIME_MULTIPLIER
