extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_pit_packet.gd"

var buffers := [
	[PackedByteArray([6, 26, 0, 3, 0, 0, 1, 4, 0, 0, 1, 0, 255, 255, 255, 255, 2,
			0, 0, 0, 0, 0, 0, 0])],
	[PackedByteArray([6, 26, 0, 1, 0, 0, 1, 2, 3, 0, 1, 0, 255, 255, 255, 255, 2,
			0, 2, 0, 0, 0, 0, 0])],
	[PackedByteArray([6, 26, 0, 3, 0, 0, 1, 4, 5, 0, 1, 0, 2, 2, 2, 2, 162, 56, 2,
			0, 0, 0, 0, 0])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimPITPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimPITPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimPITPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.plid).is_equal(buffer.decode_u8(3))
	_test = assert_int(packet.laps_done).is_equal(buffer.decode_u16(4))
	_test = assert_int(packet.flags).is_equal(buffer.decode_u16(6))
	_test = assert_int(packet.fuel_add).is_equal(buffer.decode_u8(8))
	_test = assert_int(packet.penalty).is_equal(buffer.decode_u8(9))
	_test = assert_int(packet.num_stops).is_equal(buffer.decode_u8(10))
	_test = assert_int(buffer.decode_u8(11)).is_zero()
	for i in packet.tyres.size():
		_test = assert_int(packet.tyres[i]).is_equal(buffer.decode_u8(12 + i))
	_test = assert_int(packet.work).is_equal(buffer.decode_u32(16))
	_test = assert_int(buffer.decode_u32(20)).is_zero()
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)
