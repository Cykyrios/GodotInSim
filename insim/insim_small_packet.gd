class_name InSimSmallPacket
extends InSimPacket


var value := 0


func _init(req := 0) -> void:
	size = 8
	type = InSim.Packet.ISP_SMALL
	req_i = req
	super()


func fill_buffer() -> void:
	update_req_i()
	data_offset = HEADER_SIZE
	add_unsigned(value)
