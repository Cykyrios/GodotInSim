extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_obh_packet.gd"

var epsilon := 1e-5
var buffers := [
	[PackedByteArray([6, 51, 0, 62, 26, 0, 96, 54, 0, 77, 12, 9, 223, 3, 188, 243,
			235, 3, 208, 243, 7, 0, 178, 9])],
	[PackedByteArray([6, 51, 0, 59, 24, 0, 76, 57, 0, 128, 35, 8, 128, 7, 177, 245,
			144, 7, 107, 245, 7, 0, 174, 9])],
	[PackedByteArray([6, 51, 0, 20, 73, 0, 65, 73, 0, 185, 25, 8, 56, 251, 28, 214,
			113, 251, 7, 214, 7, 0, 174, 9])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimOBHPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimOBHPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimOBHPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.plid).is_equal(buffer.decode_u8(3))
	_test = assert_int(packet.sp_close).is_equal(buffer.decode_u16(4))
	_test = assert_float(packet.gis_closing_speed) \
			.is_equal_approx(buffer.decode_u16(4) / InSimOBHPacket.CLOSING_SPEED_MULTIPLIER,
			epsilon)
	_test = assert_int(packet.time).is_equal(buffer.decode_u16(6))
	_test = assert_array(packet.object.get_buffer()) \
			.is_equal(buffer.slice(8, 8 + CarContObj.STRUCT_SIZE))
	_test = assert_int(packet.x).is_equal(buffer.decode_s16(CarContObj.STRUCT_SIZE + 8))
	_test = assert_int(packet.y).is_equal(buffer.decode_s16(CarContObj.STRUCT_SIZE + 10))
	_test = assert_int(packet.z).is_equal(buffer.decode_u8(CarContObj.STRUCT_SIZE + 12))
	_test = assert_vector(packet.gis_position).is_equal_approx(Vector3(
		buffer.decode_s16(CarContObj.STRUCT_SIZE + 8) / InSimOBHPacket.POSITION_XY_MULTIPLIER,
		buffer.decode_s16(CarContObj.STRUCT_SIZE + 10) / InSimOBHPacket.POSITION_XY_MULTIPLIER,
		buffer.decode_u8(CarContObj.STRUCT_SIZE + 12) / InSimOBHPacket.POSITION_Z_MULTIPLIER
	), epsilon * Vector3.ONE)
	_test = assert_int(packet.sp1).is_equal(buffer.decode_u8(CarContObj.STRUCT_SIZE + 13))
	_test = assert_int(packet.index).is_equal(buffer.decode_u8(CarContObj.STRUCT_SIZE + 14))
	_test = assert_int(packet.obh_flags).is_equal(buffer.decode_u8(CarContObj.STRUCT_SIZE + 15))
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)
