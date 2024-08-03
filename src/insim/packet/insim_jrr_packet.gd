class_name InSimJRRPacket
extends InSimPacket

## Join Request Reply packet - send one of these back to LFS in response to a join request

const PACKET_SIZE := 16
const PACKET_TYPE := InSim.Packet.ISP_JRR
var plid := 0  ## ZERO when this is a replay to a join request - SET to move a car

var ucid := 0  ## set when this is a reply to a join request - ignored when moving a car
var action := 0  ## 1 - allow / 0 - reject (should send message to user)
var sp2 := 0
var sp3 := 0

var start_pos := ObjectInfo.new()  ## 0: use default start point / Flags = 0x80: set start point


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	sendable = true


func _fill_buffer() -> void:
	super()
	add_byte(plid)
	add_byte(ucid)
	add_byte(action)
	add_byte(sp2)
	add_byte(sp3)
	var start_pos_buffer := start_pos.get_buffer()
	for byte in start_pos_buffer:
		add_byte(byte)


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": plid,
		"UCID": ucid,
		"Action": action,
		"Sp2": sp2,
		"Sp3": sp3,
		"StartPos": start_pos,
	}
