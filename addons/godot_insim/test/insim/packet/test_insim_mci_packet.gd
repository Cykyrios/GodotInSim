extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_mci_packet.gd"

var buffers := [
	[PackedByteArray([15, 38, 1, 2, 0, 0, 1, 0, 3, 1, 64, 0, 52, 16, 22, 253, 231,
			63, 255, 254, 233, 30, 2, 0, 0, 0, 0, 0, 1, 152, 51, 0, 0, 0, 1, 0, 2,
			2, 128, 0, 31, 192, 17, 253, 214, 159, 252, 254, 89, 31, 2, 0, 0, 0, 0,
			0, 255, 151, 48, 0])],
	[PackedByteArray([15, 38, 1, 2, 0, 0, 3, 0, 3, 1, 64, 0, 212, 77, 97, 255, 140,
			147, 195, 253, 220, 30, 2, 0, 44, 24, 22, 163, 252, 161, 152, 250, 0, 0,
			1, 0, 2, 2, 128, 0, 32, 192, 17, 253, 218, 159, 252, 254, 89, 31, 2, 0,
			0, 0, 0, 0, 254, 151, 47, 0])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimMCIPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimMCIPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * packet.size_multiplier)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.num_cars).is_equal(buffer.decode_u8(3))
	var mci_buffer := PackedByteArray()
	for i in packet.info.size():
		mci_buffer.append_array(packet.info[i].get_buffer())
	_test = assert_array(mci_buffer).is_equal(buffer.slice(4))
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)
