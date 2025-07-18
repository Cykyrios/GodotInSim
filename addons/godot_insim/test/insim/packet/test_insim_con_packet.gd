extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_con_packet.gd"

var epsilon := 1e-5


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := [
	[PackedByteArray([10, 50, 0, 0, 9, 0, 106, 16, 1, 0, 0, 255, 240, 0, 48, 40, 245, 246, 2,
			251, 158, 255, 242, 24, 3, 0, 0, 255, 240, 0, 64, 41, 244, 245, 2, 251, 147, 255,
			178, 24])],
	[PackedByteArray([10, 50, 0, 0, 65, 0, 254, 38, 1, 0, 0, 220, 0, 48, 16, 17, 130, 53, 3,
			6, 159, 27, 131, 205, 3, 0, 0, 6, 0, 0, 80, 1, 37, 124, 0, 252, 206, 27, 87, 205])],
	[PackedByteArray([10, 50, 0, 0, 76, 0, 36, 63, 15, 0, 0, 5, 16, 0, 16, 23, 18, 17, 0, 14,
			228, 209, 74, 5, 67, 0, 0, 5, 11, 0, 16, 31, 19, 17, 243, 9, 4, 210, 6, 5])],
]) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimCONPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimCONPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimCONPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.zero).is_equal(buffer.decode_u8(3))
	_test = assert_int(packet.sp_close).is_equal(buffer.decode_u16(4))
	_test = (
		assert_float(packet.gis_closing_speed)
		.is_equal_approx(packet.sp_close / InSimCONPacket.CLOSING_SPEED_MULTIPLIER, epsilon)
	)
	_test = assert_int(packet.time).is_equal(buffer.decode_u16(6))
	_test = (
		assert_float(packet.gis_time)
		.is_equal_approx(packet.time / InSimCONPacket.TIME_MULTIPLIER, epsilon)
	)
	_test = (
		assert_array(packet.car_a.get_buffer())
		.is_equal(buffer.slice(8, 8 + CarContact.STRUCT_SIZE))
	)
	_test = (
		assert_array(packet.car_b.get_buffer())
		.is_equal(buffer.slice(8 + CarContact.STRUCT_SIZE))
	)
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)
