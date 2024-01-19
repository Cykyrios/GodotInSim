class_name InSimCPPPacket
extends InSimPacket


const PACKET_SIZE := 32
const PACKET_TYPE := InSim.Packet.ISP_CPP
var zero := 0

var pos := Vector3i.ZERO

var heading := 0
var pitch := 0
var roll := 0

var view_plid := 255
var ingame_cam := 255

var fov := 70.0

var time := 0
var flags := 0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	zero = read_byte(packet)
	pos.x = read_int(packet)
	pos.y = read_int(packet)
	pos.z = read_int(packet)
	heading = read_word(packet)
	pitch = read_word(packet)
	roll = read_word(packet)
	view_plid = read_byte(packet)
	ingame_cam = read_byte(packet)
	fov = read_float(packet)
	time = read_word(packet)
	flags = read_word(packet)


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
