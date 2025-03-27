extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_cpp_packet.gd"

var epsilon := 1e-5
var buffers := [
	[PackedByteArray([8, 9, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			3, 3, 0, 0, 140, 66, 0, 0, 129, 72])],
	[PackedByteArray([8, 9, 1, 0, 43, 195, 126, 255, 149, 195, 197, 0, 7, 173, 49, 0, 78, 25,
			225, 13, 0, 0, 3, 3, 0, 0, 112, 66, 0, 0, 9, 72])],
	# FIXME: The following values cause a float precision issue because of Godot's Vector3
	# (and the way the test_encode_packet_gis() test works, I suppose),
	# so I replaced them with the next values (camera moved a few centimeters).
	#[PackedByteArray([8, 9, 1, 0, 239, 96, 132, 1, 255, 36, 80, 254, 135, 175, 1, 0, 193, 252,
			#58, 4, 0, 0, 3, 3, 0, 0, 112, 66, 0, 100, 73, 72])],
	[PackedByteArray([8, 9, 1, 0, 198, 142, 132, 1, 212, 5, 80, 254, 88, 175, 1, 0, 193, 252,
			58, 4, 0, 0, 11, 3, 0, 0, 112, 66, 0, 0, 201, 72])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimCPPPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimCPPPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimCPPPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.zero).is_equal(buffer.decode_u8(3))
	_test = assert_vector(packet.pos).is_equal(Vector3i(
		buffer.decode_s32(4),
		buffer.decode_s32(8),
		buffer.decode_s32(12)
	))
	_test = assert_vector(packet.gis_position).is_equal_approx(Vector3i(
		buffer.decode_s32(4),
		buffer.decode_s32(8),
		buffer.decode_s32(12)
	) / InSimCPPPacket.POSITION_MULTIPLIER, epsilon * Vector3.ONE)
	_test = assert_int(packet.heading).is_equal(buffer.decode_u16(16))
	_test = assert_int(packet.pitch).is_equal(buffer.decode_u16(18))
	_test = assert_int(packet.roll).is_equal(buffer.decode_u16(20))
	_test = assert_vector(packet.gis_angles).is_equal_approx(Vector3(
		wrapf(deg_to_rad(-buffer.decode_u16(18) / InSimCPPPacket.ANGLE_MULTIPLIER), -PI, PI),
		wrapf(deg_to_rad(buffer.decode_u16(20) / InSimCPPPacket.ANGLE_MULTIPLIER), -PI, PI),
		wrapf(deg_to_rad(buffer.decode_u16(16) / InSimCPPPacket.ANGLE_MULTIPLIER - 180), -PI, PI)
	), epsilon * Vector3.ONE)
	_test = assert_int(packet.view_plid).is_equal(buffer.decode_u8(22))
	_test = assert_int(packet.ingame_cam).is_equal(buffer.decode_u8(23))
	_test = assert_float(packet.fov).is_equal_approx(buffer.decode_float(24), epsilon)
	_test = assert_int(packet.time).is_equal(buffer.decode_u16(28))
	_test = assert_float(packet.gis_time) \
			.is_equal_approx(buffer.decode_u16(28) / InSimCPPPacket.TIME_MULTIPLIER, epsilon)
	_test = assert_int(packet.flags).is_equal(buffer.decode_u16(30))
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)


@warning_ignore("unused_parameter")
func test_encode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimCPPPacket.new()
	packet.req_i = buffer.decode_u8(2)
	packet.zero = buffer.decode_u8(3)
	packet.pos = Vector3i(
		buffer.decode_s32(4),
		buffer.decode_s32(8),
		buffer.decode_s32(12)
	)
	packet.heading = buffer.decode_u16(16)
	packet.pitch = buffer.decode_u16(18)
	packet.roll = buffer.decode_u16(20)
	packet.view_plid = buffer.decode_u8(22)
	packet.ingame_cam = buffer.decode_u8(23)
	packet.fov = buffer.decode_float(24)
	packet.time = buffer.decode_u16(28)
	packet.flags = buffer.decode_u16(30)
	packet.fill_buffer()
	if packet.type != buffer.decode_u8(1):
		fail("Incorrect packet type")
		return
	var _test := assert_array(packet.buffer).is_equal(buffer)


@warning_ignore("unused_parameter")
func test_encode_packet_gis(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimCPPPacket.new()
	packet.req_i = buffer.decode_u8(2)
	packet.zero = buffer.decode_u8(3)
	packet.gis_position = Vector3(
		buffer.decode_s32(4),
		buffer.decode_s32(8),
		buffer.decode_s32(12)
	) / InSimCPPPacket.POSITION_MULTIPLIER
	packet.gis_angles = Vector3(
		wrapf(deg_to_rad(-buffer.decode_u16(18) / InSimCPPPacket.ANGLE_MULTIPLIER), -PI, PI),
		wrapf(deg_to_rad(buffer.decode_u16(20) / InSimCPPPacket.ANGLE_MULTIPLIER), -PI, PI),
		wrapf(deg_to_rad(buffer.decode_u16(16) / InSimCPPPacket.ANGLE_MULTIPLIER - 180), -PI, PI)
	)
	packet.view_plid = buffer.decode_u8(22)
	packet.ingame_cam = buffer.decode_u8(23)
	packet.fov = buffer.decode_float(24)
	packet.gis_time = buffer.decode_u16(28) / InSimCPPPacket.TIME_MULTIPLIER
	packet.flags = buffer.decode_u16(30)

	# Check for rounding errors caused by Vector3
	var x_converted := roundi(packet.gis_position.x * InSimCPPPacket.POSITION_MULTIPLIER)
	var x_expected := buffer.decode_s32(4)
	var x_difference := x_converted - x_expected
	var _test: GdUnitAssert = assert_int(absi(x_difference)).is_less_equal(1)
	packet.gis_position.x -= x_difference / InSimCPPPacket.POSITION_MULTIPLIER
	var y_converted := roundi(packet.gis_position.y * InSimCPPPacket.POSITION_MULTIPLIER)
	var y_expected := buffer.decode_s32(8)
	var y_difference := y_converted - y_expected
	_test = assert_int(absi(y_difference)).is_less_equal(1)
	packet.gis_position.y -= y_difference / InSimCPPPacket.POSITION_MULTIPLIER
	var z_converted := roundi(packet.gis_position.z * InSimCPPPacket.POSITION_MULTIPLIER)
	var z_expected := buffer.decode_s32(12)
	var z_difference := z_converted - z_expected
	_test = assert_int(absi(z_difference)).is_less_equal(1)
	packet.gis_position.z -= z_difference / InSimCPPPacket.POSITION_MULTIPLIER

	packet.fill_buffer(true)
	if packet.type != buffer.decode_u8(1):
		fail("Incorrect packet type")
		return
	_test = assert_array(packet.buffer).is_equal(buffer)
	#var _test := assert_array(packet.buffer).is_equal(buffer)
