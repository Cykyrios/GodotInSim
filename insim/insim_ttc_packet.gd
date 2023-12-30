class_name InSimTTCPacket
extends InSimPacket


var ucid := 0
var b1 := 0
var b2 := 0
var b3 := 0


func _init(req := 0) -> void:
	size = 8
	type = InSim.Packet.ISP_TTC
	req_i = req
	super()


func fill_buffer() -> void:
	update_req_i()
	data_offset = HEADER_SIZE
	add_unsigned(ucid)
	add_unsigned(b1)
	add_unsigned(b2)
	add_unsigned(b3)
