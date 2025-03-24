extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_hcp_packet.gd"

var buffers := [
	[PackedByteArray([17, 56, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])],
	[PackedByteArray([17, 56, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 25,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])],
	[PackedByteArray([17, 56, 0, 0, 50, 5, 70, 8, 100, 15, 100, 12, 100, 10, 150, 5,
			150, 15, 25, 5, 10, 2, 50, 5, 75, 8, 50, 10, 50, 10, 70, 7, 50, 10, 50, 10,
			50, 12, 50, 13, 100, 15, 20, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_encode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimHCPPacket.new()
	packet.req_i = buffer.decode_u8(2)
	packet.zero = buffer.decode_u8(3)
	var info_buffer := buffer.slice(4)
	for i in int(info_buffer.size() as float / CarHandicap.STRUCT_SIZE):
		var h_mass := info_buffer.decode_u8(i * CarHandicap.STRUCT_SIZE)
		var h_tres := info_buffer.decode_u8(i * CarHandicap.STRUCT_SIZE + 1)
		packet.car_hcp[i] = CarHandicap.create(h_mass, h_tres)
	packet.fill_buffer()
	if packet.type != buffer.decode_u8(1):
		fail("Incorrect packet type")
		return
	var _test := assert_array(packet.buffer).is_equal(buffer)
