class_name InSimMODPacket
extends InSimPacket


const PACKET_SIZE := 20
const PACKET_TYPE := InSim.Packet.ISP_MOD
var zero := 0

var bits16 := 0
var refresh_rate := 0
var width := 0
var height := 0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _fill_buffer() -> void:
	super()
	add_byte(zero)
	add_int(bits16)
	add_int(refresh_rate)
	add_int(width)
	add_int(height)


func _get_data_dictionary() -> Dictionary:
	return {
		"Zero": zero,
		"Bits16": bits16,
		"RR": refresh_rate,
		"Width": width,
		"Height": height,
	}
