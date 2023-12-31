class_name InSimTTCPacket
extends InSimPacket


var sub_type := InSim.TTC.TTC_NONE
var ucid := 0
var b1 := 0
var b2 := 0
var b3 := 0


func _init(req := 0) -> void:
	size = 8
	type = InSim.Packet.ISP_TTC
	req_i = req
	super()


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != size:
		push_error("ISP_TTC packet expected size %d, got %d." % [size, packet_size])
		return
	super(packet)
	data_offset = HEADER_SIZE - 1
	sub_type = read_byte(packet) as InSim.TTC
	ucid = read_byte(packet)
	b1 = read_byte(packet)
	b2 = read_byte(packet)
	b3 = read_byte(packet)


func _fill_buffer() -> void:
	update_req_i()
	data_offset = 3
	add_byte(sub_type)
	data_offset = HEADER_SIZE
	add_unsigned(ucid)
	add_unsigned(b1)
	add_unsigned(b2)
	add_unsigned(b3)


func _get_data_dictionary() -> Dictionary:
	var dict := {
		"SubT": sub_type,
		"UCID": ucid,
		"B1": b1,
		"B2": b2,
		"B3": b3,
	}
	return dict
