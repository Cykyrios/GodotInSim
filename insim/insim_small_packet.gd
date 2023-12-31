class_name InSimSmallPacket
extends InSimPacket


var sub_type := InSim.Small.SMALL_NONE
var value := 0


func _init(req := 0) -> void:
	size = 8
	type = InSim.Packet.ISP_SMALL
	req_i = req
	super()


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != size:
		push_error("ISP_SMALL packet expected size %d, got %d." % [size, packet_size])
		return
	super(packet)
	data_offset = HEADER_SIZE - 1
	sub_type = read_byte(packet) as InSim.Small
	value = read_unsigned(packet)


func _fill_buffer() -> void:
	update_req_i()
	data_offset = 3
	add_byte(sub_type)
	data_offset = HEADER_SIZE
	add_unsigned(value)


func _get_data_dictionary() -> Dictionary:
	var dict := {
		"SubT": sub_type,
		"UVal": value,
	}
	return dict
