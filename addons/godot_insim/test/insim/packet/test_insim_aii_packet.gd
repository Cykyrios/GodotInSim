extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_aii_packet.gd"


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


var params_decode_packet := [
	[PackedByteArray([24, 69, 1, 1, 193, 73, 162, 188, 208, 49, 134, 184, 162, 128, 49, 187, 147,
			23, 199, 191, 249, 227, 248, 59, 124, 139, 62, 186, 60, 245, 36, 185, 190, 200, 76,
			57, 56, 247, 16, 186, 253, 255, 28, 182, 213, 170, 140, 184, 181, 250, 178, 185, 48,
			98, 149, 255, 118, 255, 115, 0, 71, 82, 10, 0, 1, 1, 0, 0, 219, 67, 144, 68, 0, 0, 0,
			0, 0, 0, 0, 0, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])],
]
@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := [
	[PackedByteArray([24, 69, 1, 1, 193, 73, 162, 188, 208, 49, 134, 184, 162, 128, 49, 187, 147,
			23, 199, 191, 249, 227, 248, 59, 124, 139, 62, 186, 60, 245, 36, 185, 190, 200, 76,
			57, 56, 247, 16, 186, 253, 255, 28, 182, 213, 170, 140, 184, 181, 250, 178, 185, 48,
			98, 149, 255, 118, 255, 115, 0, 71, 82, 10, 0, 1, 1, 0, 0, 219, 67, 144, 68, 0, 0, 0,
			0, 0, 0, 0, 0, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])],
]) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimAIIPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimAIIPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimAIIPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.plid).is_equal(buffer.decode_u8(3))
	_test = (
		assert_array(packet.outsim_data.get_buffer())
		.is_equal(buffer.slice(4, 4 + OutSimMain.STRUCT_SIZE))
	)
	_test = assert_int(packet.flags).is_equal(buffer.decode_u8(OutSimMain.STRUCT_SIZE + 4))
	_test = assert_int(packet.gear).is_equal(buffer.decode_u8(OutSimMain.STRUCT_SIZE + 5))
	_test = assert_int(buffer.decode_u8(OutSimMain.STRUCT_SIZE + 6)).is_zero()
	_test = assert_int(buffer.decode_u8(OutSimMain.STRUCT_SIZE + 7)).is_zero()
	_test = assert_float(packet.rpm).is_equal(buffer.decode_float(OutSimMain.STRUCT_SIZE + 8))
	_test = assert_float(buffer.decode_float(OutSimMain.STRUCT_SIZE + 12)).is_zero()
	_test = assert_float(buffer.decode_float(OutSimMain.STRUCT_SIZE + 16)).is_zero()
	_test = assert_int(packet.show_lights).is_equal(buffer.decode_u32(OutSimMain.STRUCT_SIZE + 20))
	_test = assert_int(buffer.decode_u32(OutSimMain.STRUCT_SIZE + 24)).is_zero()
	_test = assert_int(buffer.decode_u32(OutSimMain.STRUCT_SIZE + 28)).is_zero()
	_test = assert_int(buffer.decode_u32(OutSimMain.STRUCT_SIZE + 32)).is_zero()
	_test = assert_array(packet.buffer).is_equal(buffer)
