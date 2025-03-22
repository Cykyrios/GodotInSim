extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_bfn_packet.gd"


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := [
	[PackedByteArray([2, 42, 0, 2, 0, 0, 0, 0])],
	[PackedByteArray([2, 42, 0, 3, 0, 0, 0, 0])],
]) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimBFNPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimBFNPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimBFNPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.subtype).is_equal(buffer.decode_u8(3))
	_test = assert_int(packet.ucid).is_equal(buffer.decode_u8(4))
	_test = assert_int(packet.click_id).is_equal(buffer.decode_u8(5))
	_test = assert_int(packet.click_max).is_equal(buffer.decode_u8(6))
	_test = assert_int(packet.inst).is_equal(buffer.decode_u8(7))
	_test = assert_array(packet.buffer).is_equal(buffer)


@warning_ignore("unused_parameter")
func test_encode_packet(buffer: PackedByteArray, test_parameters := [
	[PackedByteArray([2, 42, 0, 0, 0, 2, 5, 0])],
	[PackedByteArray([2, 42, 0, 1, 0, 0, 0, 0])],
]) -> void:
	var packet := InSimBFNPacket.new()
	packet.req_i = buffer.decode_u8(2)
	packet.subtype = buffer.decode_u8(3) as InSim.ButtonFunction
	packet.ucid = buffer.decode_u8(4)
	packet.click_id = buffer.decode_u8(5)
	packet.click_max = buffer.decode_u8(6)
	packet.inst = buffer.decode_u8(7)
	packet.fill_buffer()
	if packet.type != buffer.decode_u8(1):
		fail("Incorrect packet type")
		return
	var _test := assert_array(packet.buffer).is_equal(buffer)
