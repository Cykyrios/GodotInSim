class_name InSimJRRPacket
extends InSimPacket


const PACKET_SIZE := 16
const PACKET_TYPE := InSim.Packet.ISP_JRR
var player_id := 0

var ucid := 0
var action := 0
var sp2 := 0
var sp3 := 0

var start_pos := ObjectInfo.new()


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _fill_buffer() -> void:
	super()
	add_byte(player_id)
	add_byte(ucid)
	add_byte(action)
	add_byte(sp2)
	add_byte(sp3)
	var start_pos_buffer := start_pos.get_buffer()
	for byte in start_pos_buffer:
		add_byte(byte)


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": player_id,
		"UCID": ucid,
		"Action": action,
		"Sp2": sp2,
		"Sp3": sp3,
		"StartPos": start_pos,
	}