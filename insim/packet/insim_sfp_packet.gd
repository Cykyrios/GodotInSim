class_name InSimSFPPacket
extends InSimPacket


const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_SFP
var zero := 0

var flag := 0
var off_on := 0
var sp3 := 0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _get_data_dictionary() -> Dictionary:
	var data := {
		"Zero": zero,
		"Flag": flag,
		"OffOn": off_on,
		"Sp3": sp3,
	}
	return data


func _fill_buffer() -> void:
	super()
	add_byte(zero)
	add_word(flag)
	add_byte(off_on)
	add_byte(sp3)
