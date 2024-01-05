class_name InSimSCCPacket
extends InSimPacket


const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_SCC
var zero := 0

var view_plid := 255
var ingame_cam := 255
var sp2 := 0
var sp3 := 0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _fill_buffer() -> void:
	super()
	add_byte(zero)
	add_byte(view_plid)
	add_byte(ingame_cam)
	add_byte(sp2)
	add_byte(sp3)


func _get_data_dictionary() -> Dictionary:
	return {
		"Zero": zero,
		"ViewPLID": view_plid,
		"InGameCam": ingame_cam,
		"Sp2": sp2,
		"Sp3": sp3,
	}
