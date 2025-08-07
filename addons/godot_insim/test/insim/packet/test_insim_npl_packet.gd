extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_npl_packet.gd"

var buffers := [
	[PackedByteArray([19, 21, 250, 62, 29, 4, 129, 0, 94, 55, 50, 49, 32, 67, 46,
			66, 105, 115, 115, 101, 121, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 45, 32,
			50, 49, 32, 45, 0, 112, 201, 45, 148, 0, 69, 67, 72, 95, 50, 49, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 14, 30, 0, 0, 0, 0, 0, 0, 15, 0, 100])],
	[PackedByteArray([19, 21, 250, 20, 38, 4, 1, 0, 94, 55, 50, 53, 32, 71, 46, 32,
		71, 225, 98, 111, 114, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 201, 45, 148, 0, 69, 67, 72, 95, 83, 49, 68, 50, 53, 0, 0, 0, 0, 0, 0, 0,
		1, 1, 1, 1, 0, 14, 26, 0, 0, 0, 0, 0, 0, 16, 0, 100])],
	[PackedByteArray([19, 21, 250, 64, 35, 4, 129, 0, 94, 55, 56, 55, 32, 78, 46,
			80, 117, 110, 116, 111, 108, 97, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 101,
			115, 0, 0, 0, 0, 0, 201, 45, 148, 0, 112, 97, 99, 105, 102, 105, 116, 101,
			99, 104, 95, 50, 53, 0, 0, 0, 1, 1, 1, 1, 0, 14, 30, 0, 0, 0, 0, 0, 0, 16, 0, 100])],
	[PackedByteArray([19, 21, 250, 61, 41, 4, 129, 32, 94, 55, 56, 56, 32, 83, 46,
			32, 65, 103, 111, 115, 116, 105, 110, 104, 111, 0, 0, 0, 0, 0, 0, 0, 76,
			70, 83, 118, 50, 32, 50, 53, 201, 45, 148, 0, 78, 79, 83, 76, 69, 95, 50,
			48, 50, 52, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 14, 30, 0, 0, 0, 0, 0, 0, 15, 2, 100])],
	[PackedByteArray([19, 21, 250, 63, 7, 4, 129, 32, 94, 55, 57, 54, 32, 94, 50,
			82, 94, 49, 46, 94, 50, 75, 114, 111, 110, 112, 117, 154, 115, 0, 0, 0,
			94, 50, 82, 111, 110, 121, 0, 0, 201, 45, 148, 0, 82, 111, 110, 121, 45,
			50, 48, 50, 52, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 14, 30, 0, 0, 0, 0, 0,
			0, 15, 2, 100])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimNPLPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimNPLPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimNPLPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.plid).is_equal(buffer.decode_u8(3))
	_test = assert_int(packet.ucid).is_equal(buffer.decode_u8(4))
	_test = assert_int(packet.player_type).is_equal(buffer.decode_u8(5))
	_test = assert_int(packet.flags).is_equal(buffer.decode_u16(6))
	_test = assert_str(packet.player_name).is_equal(
		LFSText.lfs_bytes_to_unicode(buffer.slice(8, 32))
	)
	_test = assert_str(packet.plate).is_equal(
		LFSText.lfs_bytes_to_unicode(buffer.slice(32, 40), false)
	)
	_test = assert_str(packet.car_name).is_equal(
		LFSText.car_name_from_lfs_bytes(buffer.slice(40, 44))
	)
	_test = assert_str(packet.skin_name).is_equal(
		LFSText.lfs_bytes_to_unicode(buffer.slice(44, 60))
	)
	for i in packet.tyres.size():
		_test = assert_int(packet.tyres[i]).is_equal(buffer.decode_u8(60 + i))
	_test = assert_int(packet.h_mass).is_equal(buffer.decode_u8(64))
	_test = assert_int(packet.h_tres).is_equal(buffer.decode_u8(65))
	_test = assert_int(packet.model).is_equal(buffer.decode_u8(66))
	_test = assert_int(packet.passengers).is_equal(buffer.decode_u8(67))
	_test = assert_int(packet.rw_adjust).is_equal(buffer.decode_u8(68))
	_test = assert_int(packet.fw_adjust).is_equal(buffer.decode_u8(69))
	_test = assert_int(buffer.decode_u8(70)).is_zero()
	_test = assert_int(buffer.decode_u8(71)).is_zero()
	_test = assert_int(packet.setup_flags).is_equal(buffer.decode_u8(72))
	_test = assert_int(packet.num_players).is_equal(buffer.decode_u8(73))
	_test = assert_int(packet.config).is_equal(buffer.decode_u8(74))
	_test = assert_int(packet.fuel).is_equal(buffer.decode_u8(75))
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)
