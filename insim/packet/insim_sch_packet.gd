class_name InSimSCHPacket
extends InSimPacket


var char_byte := 0
var flags := 0
var spare2 := 0
var spare3 := 0


func _init() -> void:
	size = 8
	type = InSim.Packet.ISP_SCH
	super()


func _get_data_dictionary() -> Dictionary:
	var data := {
		"CharB": char_byte,
		"Flags": flags,
		"Spare2": spare2,
		"Spare3": spare3,
	}
	return data


func _fill_buffer() -> void:
	data_offset = HEADER_SIZE
	add_byte(char_byte)
	add_byte(flags)
	add_byte(spare2)
	add_byte(spare3)
