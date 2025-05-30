extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_ipb_packet.gd"

var buffers := [
	[PackedByteArray([2, 67, 0, 0, 0, 0, 0, 0])],
	[PackedByteArray([2, 67, 1, 1, 0, 0, 0, 0, 11, 22, 33, 44])],
	[PackedByteArray([2, 67, 0, 2, 0, 0, 0, 0, 127, 0, 0, 1, 11, 22, 33, 44])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimIPBPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimIPBPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimIPBPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.numb).is_equal(buffer.decode_u8(3))
	_test = assert_int(packet.sp0).is_equal(buffer.decode_u8(4))
	_test = assert_int(packet.sp1).is_equal(buffer.decode_u8(5))
	_test = assert_int(packet.sp2).is_equal(buffer.decode_u8(6))
	_test = assert_int(packet.sp3).is_equal(buffer.decode_u8(7))
	var ip_buffer := PackedByteArray()
	var _discard := ip_buffer.resize(4 * packet.ban_ips.size())
	for i in packet.ban_ips.size():
		ip_buffer.encode_u32(4 * i, packet.ban_ips[i].address_int)
	_test = assert_array(ip_buffer).is_equal(buffer.slice(8))
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)


@warning_ignore("unused_parameter")
func test_encode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimIPBPacket.new()
	packet.req_i = buffer.decode_u8(2)
	packet.numb = buffer.decode_u8(3)
	packet.sp0 = buffer.decode_u8(4)
	packet.sp1 = buffer.decode_u8(5)
	packet.sp2 = buffer.decode_u8(6)
	packet.sp3 = buffer.decode_u8(7)
	var _discard := packet.ban_ips.resize(packet.numb)
	var ip_buffer := buffer.slice(8)
	for i in packet.numb:
		var ip := IPAddress.new()
		ip.fill_from_int(ip_buffer.decode_u32(i * IPAddress.STRUCT_SIZE))
		packet.ban_ips[i] = ip
	packet.fill_buffer()
	if packet.type != buffer.decode_u8(1):
		fail("Incorrect packet type")
		return
	var _test := assert_array(packet.buffer).is_equal(buffer)


func test_add_too_many_ips() -> void:
	var ips: Array[IPAddress] = []
	var count := InSimIPBPacket.IPB_MAX_BANS + 1
	for i in count:
		var ip := IPAddress.new()
		ip.fill_from_array([i + 1, i + 1, i + 1, i + 1])
		ips.append(ip)
	var packet := InSimIPBPacket.create(count, ips)
	packet.fill_buffer()
	var _test := assert_int(packet.ban_ips.size()).is_equal(InSimIPBPacket.IPB_MAX_BANS)
