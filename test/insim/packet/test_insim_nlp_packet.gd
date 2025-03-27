extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_nlp_packet.gd"

var buffers := [
	[PackedByteArray([3, 37, 1, 1, 214, 1, 1, 0, 3, 0, 0, 0])],
	[PackedByteArray([24, 37, 1, 15, 97, 0, 1, 0, 2, 13, 87, 1, 43, 0, 53, 2, 116,
			1, 43, 0, 19, 1, 219, 0, 42, 0, 23, 3, 187, 0, 41, 0, 56, 5, 97, 0, 1,
			0, 30, 14, 50, 0, 40, 0, 57, 6, 2, 2, 40, 0, 18, 7, 7, 1, 40, 0, 58, 8,
			255, 0, 40, 0, 59, 9, 189, 1, 38, 0, 24, 10, 157, 1, 35, 0, 17, 11, 97,
			0, 1, 0, 61, 15, 89, 0, 41, 0, 62, 4, 165, 0, 13, 0, 46, 12, 0, 0])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimNLPPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimNLPPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimNLPPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.num_players).is_equal(buffer.decode_u8(3))
	var info_buffer := PackedByteArray()
	for player in packet.num_players:
		info_buffer.append_array(packet.info[player].get_buffer())
	if packet.num_players % 2 > 0:
		info_buffer.append_array([0, 0])
	_test = assert_array(info_buffer).is_equal(buffer.slice(4))
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)
