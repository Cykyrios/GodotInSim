extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_plh_packet.gd"

var buffers := [
	[PackedByteArray([1, 66, 0, 0])],
	[PackedByteArray([3, 66, 0, 2, 1, 3, 50, 5, 2, 3, 50, 5])],
	[PackedByteArray([2, 66, 0, 1, 2, 3, 200, 50])],
	[PackedByteArray([2, 66, 0, 1, 2, 131, 200, 50])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimPLHPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimPLHPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * packet.size_multiplier)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.nump).is_equal(buffer.decode_u8(3))
	for i in packet.nump:
		_test = (
			assert_array(packet.hcaps[i].get_buffer())
			.is_equal(buffer.slice(
				4 + i * PlayerHandicap.STRUCT_SIZE, 4 + (i + 1) * PlayerHandicap.STRUCT_SIZE
			))
		)
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)


@warning_ignore("unused_parameter")
func test_encode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimPLHPacket.new()
	packet.req_i = buffer.decode_u8(2)
	packet.nump = buffer.decode_u8(3)
	for i in packet.nump:
		var hcap := PlayerHandicap.new()
		hcap.set_from_buffer(buffer.slice(4 + i * PlayerHandicap.STRUCT_SIZE,
				4 + (i + 1) * PlayerHandicap.STRUCT_SIZE))
		packet.hcaps.append(hcap)
	packet.fill_buffer()
	if packet.type != buffer.decode_u8(1):
		fail("Incorrect packet type")
		return
	var _test := assert_array(packet.buffer).is_equal(buffer)


func test_trim_packet() -> void:
	var handicaps: Array[PlayerHandicap] = []
	for i in 3:
		var handicap := PlayerHandicap.create(i, 0, 0, 0)
		handicaps.append(handicap)
	var count := 2
	var packet := InSimPLHPacket.create(count, handicaps)
	var _test := (
		assert_int(packet.size)
		.is_equal(InSimPLHPacket.PACKET_BASE_SIZE + count * PlayerHandicap.STRUCT_SIZE)
	)
