extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_axm_packet.gd"


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


var params_decode_packet := [
	[PackedByteArray([18, 54, 0, 8, 0, 0, 1, 0, 96, 4, 173, 38, 59, 0, 4, 128, 161, 0, 27, 38,
			55, 0, 4, 128, 245, 0, 31, 22, 0, 0, 4, 128, 235, 252, 168, 13, 1, 0, 4, 128, 255, 0,
			25, 22, 0, 13, 0, 128, 111, 4, 170, 38, 59, 14, 0, 128, 177, 0, 26, 38, 55, 15, 0, 0,
			246, 252, 168, 13, 1, 12, 0, 128])],
	[PackedByteArray([4, 54, 0, 1, 0, 1, 0, 0, 140, 253, 227, 14, 0, 0, 144, 128])],
	[PackedByteArray([4, 54, 0, 1, 0, 2, 0, 0, 199, 253, 140, 15, 0, 0, 144, 128])],
	[PackedByteArray([2, 54, 0, 0, 0, 3, 0, 0])],
	[PackedByteArray([18, 54, 1, 8, 0, 4, 1, 0, 96, 4, 173, 38, 59, 0, 4, 128, 161, 0, 27, 38,
			55, 0, 4, 128, 245, 0, 31, 22, 0, 0, 4, 128, 235, 252, 168, 13, 1, 0, 4, 128, 255, 0,
			25, 22, 0, 13, 0, 128, 111, 4, 170, 38, 59, 14, 0, 128, 177, 0, 26, 38, 55, 15, 0, 0,
			246, 252, 168, 13, 1, 12, 0, 128])],
	[PackedByteArray([2, 54, 1, 0, 0, 5, 1, 0])],
	[PackedByteArray([18, 54, 1, 8, 0, 6, 1, 0, 96, 4, 173, 38, 59, 0, 4, 128, 161, 0, 27, 38,
			55, 0, 4, 128, 245, 0, 31, 22, 0, 0, 4, 128, 235, 252, 168, 13, 1, 0, 4, 128, 255, 0,
			25, 22, 0, 13, 0, 128, 111, 4, 170, 38, 59, 14, 0, 128, 177, 0, 26, 38, 55, 15, 0, 0,
			246, 252, 168, 13, 1, 12, 0, 128])],
	[PackedByteArray([4, 54, 0, 1, 0, 7, 0, 0, 135, 253, 58, 15, 0, 0, 0, 128])],
	[PackedByteArray([4, 54, 0, 1, 0, 8, 0, 0, 135, 253, 58, 15, 0, 0, 0, 128])],
]
@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := params_decode_packet) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimAXMPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimAXMPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimAXMPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.num_objects).is_equal(buffer.decode_u8(3))
	_test = assert_int(packet.ucid).is_equal(buffer.decode_u8(4))
	_test = assert_int(packet.pmo_action).is_equal(buffer.decode_u8(5))
	_test = assert_int(packet.pmo_flags).is_equal(buffer.decode_u8(6))
	_test = assert_int(packet.sp3).is_equal(buffer.decode_u8(7))
	var object_infos := buffer.slice(8)
	for i in int(object_infos.size() as float / ObjectInfo.STRUCT_SIZE):
		var info := ObjectInfo.new()
		info.set_from_buffer(buffer.slice(8 + ObjectInfo.STRUCT_SIZE * i,
				8 + ObjectInfo.STRUCT_SIZE * (i + 1)))
		packet.info.append(info)
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)


var params_encode_packet := [
	[PackedByteArray([4, 54, 0, 1, 0, 1, 0, 0, 140, 253, 227, 14, 0, 0, 144, 128])],
	[PackedByteArray([4, 54, 0, 1, 0, 2, 0, 0, 199, 253, 140, 15, 0, 0, 144, 128])],
	[PackedByteArray([2, 54, 0, 0, 0, 3, 0, 0])],
	[PackedByteArray([18, 54, 1, 8, 0, 6, 1, 0, 96, 4, 173, 38, 59, 0, 4, 128, 161, 0, 27, 38,
			55, 0, 4, 128, 245, 0, 31, 22, 0, 0, 4, 128, 235, 252, 168, 13, 1, 0, 4, 128, 255, 0,
			25, 22, 0, 13, 0, 128, 111, 4, 170, 38, 59, 14, 0, 128, 177, 0, 26, 38, 55, 15, 0, 0,
			246, 252, 168, 13, 1, 12, 0, 128])],
	[PackedByteArray([4, 54, 0, 1, 0, 8, 0, 0, 135, 253, 58, 15, 0, 0, 0, 128])],
]
@warning_ignore("unused_parameter")
func test_encode_packet(buffer: PackedByteArray, test_parameters := params_encode_packet) -> void:
	var packet := InSimAXMPacket.new()
	packet.req_i = buffer.decode_u8(2)
	packet.num_objects = buffer.decode_u8(3)
	packet.ucid = buffer.decode_u8(4)
	packet.pmo_action = buffer.decode_u8(5) as InSim.PMOAction
	packet.pmo_flags = buffer.decode_u8(6)
	packet.sp3 = buffer.decode_u8(7)
	var object_infos := buffer.slice(8)
	for i in int(object_infos.size() as float / ObjectInfo.STRUCT_SIZE):
		var info := ObjectInfo.new()
		info.set_from_buffer(buffer.slice(8 + ObjectInfo.STRUCT_SIZE * i,
				8 + ObjectInfo.STRUCT_SIZE * (i + 1)))
		packet.info.append(info)
	packet.fill_buffer()
	if packet.type != buffer.decode_u8(1):
		fail("Incorrect packet type")
		return
	var _test := assert_array(packet.buffer).is_equal(buffer)
