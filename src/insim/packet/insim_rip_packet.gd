class_name InSimRIPPacket
extends InSimPacket

## Replay Information Packet

const TIME_MULTIPLIER := 100.0

const REPLAY_NAME_MAX_LENGTH := 64  # last byte must be zero, so actual value is decreased by one

const PACKET_SIZE := 80
const PACKET_TYPE := InSim.Packet.ISP_RIP
var error := 0  ## 0 or 1 = OK / other values are listed in [enum InSim.Replay]

var mpr := 0  ## 0 = SPR / 1 = MPR
var paused := 0  ## request: pause on arrival / reply: paused state
var options := 0  ## various options - see [enum InSim.ReplayOption]
var sp3 := 0

var c_time := 0  ## (hundredths) request: destination / reply: position
var t_time := 0  ## (hundredths) request: zero / reply: replay length

var replay_name := ""  ## zero or replay name - last byte must be zero

var gis_c_time := 0.0
var gis_t_time := 0.0


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
	error = read_byte()
	mpr = read_byte()
	paused = read_byte()
	options = read_byte()
	sp3 = read_byte()
	c_time = read_unsigned()
	t_time = read_unsigned()
	replay_name = read_string(REPLAY_NAME_MAX_LENGTH)


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


func _set_values_from_gis() -> void:
	c_time = int(gis_c_time * TIME_MULTIPLIER)
	t_time = int(gis_t_time * TIME_MULTIPLIER)


func _update_gis_values() -> void:
	gis_c_time = c_time / TIME_MULTIPLIER
	gis_t_time = t_time / TIME_MULTIPLIER
