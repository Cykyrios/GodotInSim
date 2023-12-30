class_name InSimTinyPacket
extends InSimPacket


func _init(req := 0) -> void:
	size = 4
	type = InSim.Packet.ISP_TINY
	req_i = req
	super()


func fill_buffer() -> void:
	update_req_i()
