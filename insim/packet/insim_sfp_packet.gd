class_name InSimSFPPacket
extends InSimPacket


var flag := 0
var off_on := 0
var sp3 := 0


func _init() -> void:
	size = 8
	type = InSim.Packet.ISP_SFP
	super()


func _get_data_dictionary() -> Dictionary:
	var data := {
		"Flag": flag,
		"OffOn": off_on,
		"Sp3": sp3,
	}
	return data


func _fill_buffer() -> void:
	data_offset = HEADER_SIZE
	add_word(flag)
	add_byte(off_on)
	add_byte(sp3)
