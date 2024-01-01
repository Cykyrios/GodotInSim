class_name InSimMODPacket
extends InSimPacket


var bits16 := 0
var refresh_rate := 0
var width := 0
var height := 0


func _init() -> void:
	size = 20
	type = InSim.Packet.ISP_MOD
	super()


func _get_data_dictionary() -> Dictionary:
	var data := {
		"Bits16": bits16,
		"RR": refresh_rate,
		"Width": width,
		"Height": height,
	}
	return data


func _fill_buffer() -> void:
	data_offset = HEADER_SIZE
	add_int(bits16)
	add_int(refresh_rate)
	add_int(width)
	add_int(height)
