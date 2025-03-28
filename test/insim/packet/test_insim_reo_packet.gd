extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_reo_packet.gd"

var buffers := [
	[PackedByteArray([11, 36, 0, 2, 1, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])],
	[PackedByteArray([11, 36, 0, 15, 25, 5, 11, 37, 52, 53, 54, 18, 55, 23, 48, 9, 56, 58,
			67, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimREOPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimREOPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimREOPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.num_players).is_equal(buffer.decode_u8(3))
	for i in packet.num_players:
		_test = assert_int(packet.plids[i]).is_equal(buffer.decode_u8(4 + i))
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)


@warning_ignore("unused_parameter")
func test_encode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimREOPacket.new()
	packet.req_i = buffer.decode_u8(2)
	packet.num_players = buffer.decode_u8(3)
	for i in packet.num_players:
		packet.plids[i] = buffer.decode_u8(4 + i)
	packet.fill_buffer()
	if packet.type != buffer.decode_u8(1):
		fail("Incorrect packet type")
		return
	var _test := assert_array(packet.buffer).is_equal(buffer)


func test_send_packet() -> void:
	var packet := InSimREOPacket.new()
	packet.num_players = 3
	packet.plids = [1, 2, 3]
	packet.fill_buffer()
	var _test := assert_array(packet.buffer).is_equal(PackedByteArray([
		11, 36, 0, 3, 1, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	]))


func test_send_too_many_players() -> void:
	var packet := InSimREOPacket.new()
	var plids: Array[int] = []
	for i in 41:
		plids.append(i + 1)
	packet.num_players = plids.size()
	packet.plids = plids
	packet.fill_buffer()
	var _test := assert_array(packet.buffer).is_equal(PackedByteArray([
		11, 36, 0, 40, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,
		18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35,
		36, 37, 38, 39, 40
	]))
