extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_mal_packet.gd"

var buffers := [
	[PackedByteArray([2, 65, 0, 0, 0, 0, 0, 0])],
	[PackedByteArray([3, 65, 0, 1, 0, 0, 0, 0, 46, 241, 219, 0])],
	[PackedByteArray([9, 65, 0, 7, 0, 0, 0, 0, 116, 213, 169, 0, 246, 243, 139, 0,
			29, 65, 37, 0, 232, 131, 146, 0, 80, 176, 223, 0, 96, 47, 251, 0, 245, 173, 117, 0])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimMALPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimMALPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimMALPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.num_mods).is_equal(buffer.decode_u8(3))
	_test = assert_int(packet.ucid).is_equal(buffer.decode_u8(4))
	_test = assert_int(packet.flags).is_equal(buffer.decode_u8(5))
	_test = assert_int(buffer.decode_u8(6)).is_zero()
	_test = assert_int(buffer.decode_u8(7)).is_zero()
	var skin_buffer := PackedByteArray()
	var _resize := skin_buffer.resize(4 * packet.num_mods)
	for i in packet.num_mods:
		skin_buffer.encode_u32(4 * i, packet.skin_id[i])
	_test = assert_array(skin_buffer).is_equal(buffer.slice(8))
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)


@warning_ignore("unused_parameter")
func test_encode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimMALPacket.new()
	packet.req_i = buffer.decode_u8(2)
	packet.num_mods = buffer.decode_u8(3)
	packet.ucid = buffer.decode_u8(4)
	packet.flags = buffer.decode_u8(5)
	var _sp2 := buffer.decode_u8(6)
	var _sp3 := buffer.decode_u8(7)
	for i in packet.num_mods:
		packet.skin_id.append(buffer.decode_u32(8 + 4 * i))
	packet.fill_buffer()
	if packet.type != buffer.decode_u8(1):
		fail("Incorrect packet type")
		return
	var _test := assert_array(packet.buffer).is_equal(buffer)
