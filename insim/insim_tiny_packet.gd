class_name InSimTinyPacket
extends InSimPacket


var sub_type := InSim.Tiny.TINY_NONE


func _init(req := 0) -> void:
	size = 4
	type = InSim.Packet.ISP_TINY
	req_i = req
	super()


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != size:
		push_error("ISP_TINY packet expected size %d, got %d." % [size, packet_size])
		return
	super(packet)
	data_offset = HEADER_SIZE - 1
	sub_type = read_byte(packet) as InSim.Tiny


func _fill_buffer() -> void:
	update_req_i()
	data_offset = HEADER_SIZE - 1
	add_byte(sub_type)


func _get_data_dictionary() -> Dictionary:
	var dict := {
		"SubT": sub_type,
	}
	return dict
