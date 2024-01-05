class_name InSimRIPPacket
extends InSimPacket


const REPLAY_NAME_MAX_LENGTH := 64  # last byte must be zero, so actual value is decreased by one

const PACKET_SIZE := 80
const PACKET_TYPE := InSim.Packet.ISP_RIP
var error := 0

var mpr := 0
var paused := 0
var options := 0
var sp3 := 0

var c_time := 0
var t_time := 0

var replay_name := ""


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	error = read_byte(packet)
	mpr = read_byte(packet)
	paused = read_byte(packet)
	options = read_byte(packet)
	sp3 = read_byte(packet)
	c_time = read_unsigned(packet)
	t_time = read_unsigned(packet)
	replay_name = read_string(packet, REPLAY_NAME_MAX_LENGTH)


func _fill_buffer() -> void:
	super()
	add_byte(error)
	add_byte(mpr)
	add_byte(paused)
	add_byte(options)
	add_byte(sp3)
	add_unsigned(c_time)
	add_unsigned(t_time)
	add_string(REPLAY_NAME_MAX_LENGTH, replay_name)
	data_offset -= 1
	add_byte(0)  # last byte in replay name must be zero


func _get_data_dictionary() -> Dictionary:
	return {
		"Error": error,
		"MPR": mpr,
		"Paused": paused,
		"Options": options,
		"Sp3": sp3,
		"CTime": c_time,
		"TTime": t_time,
		"RName": replay_name,
	}
