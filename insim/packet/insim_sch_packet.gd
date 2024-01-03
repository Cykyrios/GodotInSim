class_name InSimSCHPacket
extends InSimPacket


const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_SCH

var zero := 0

var char_byte := 0
var flags := 0
var spare2 := 0
var spare3 := 0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _fill_buffer() -> void:
	super()
	add_byte(zero)
	add_byte(char_byte)
	add_byte(flags)
	add_byte(spare2)
	add_byte(spare3)


func _get_data_dictionary() -> Dictionary:
	return {
		"Zero": zero,
		"CharB": char_byte,
		"Flags": flags,
		"Spare2": spare2,
		"Spare3": spare3,
	}
