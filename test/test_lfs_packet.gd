extends GdUnitTestSuite

# TestSuite generated from
const __source = "res://addons/godot_insim/src/lfs_packet.gd"

var packet: LFSPacket = null


func before_test() -> void:
	packet = auto_free(preload(__source).new())


func test_add_byte() -> void:
	packet.resize_buffer(1)
	packet.add_byte(42)
	var _test := assert_array(packet.buffer).is_equal([42])


func test_add_char() -> void:
	packet.resize_buffer(1)
	packet.add_char("A")
	var _test := assert_array(packet.buffer).is_equal(LFSText.unicode_to_lfs_bytes("A"))


func test_add_float() -> void:
	packet.resize_buffer(4)
	packet.add_float(PI)
	var buffer := PackedByteArray([0, 0, 0, 0])
	buffer.encode_float(0, PI)
	var _test := assert_array(packet.buffer).is_equal(buffer)


func test_add_int() -> void:
	var number := int(PI * 1_000_000)
	packet.resize_buffer(4)
	packet.add_int(number)
	var buffer := PackedByteArray([0, 0, 0, 0])
	buffer.encode_s32(0, number)
	var _test := assert_array(packet.buffer).is_equal(buffer)


func test_add_short() -> void:
	var number := int(1337)
	packet.resize_buffer(2)
	packet.add_short(number)
	var buffer := PackedByteArray([0, 0])
	buffer.encode_s16(0, number)
	var _test := assert_array(packet.buffer).is_equal(buffer)


func test_add_string() -> void:
	var buffer_size := 24
	var text := "test"
	packet.resize_buffer(buffer_size)
	packet.add_string(buffer_size, text)
	var _test: GdUnitAssert = assert_str(LFSText.lfs_bytes_to_unicode(packet.buffer)) \
			.is_equal(text)
	var expected := LFSText.unicode_to_lfs_bytes(text)
	var _discard := expected.resize(buffer_size)
	_test = assert_array(packet.buffer).is_equal(expected)


func test_add_string_as_utf8() -> void:
	var buffer_size := 24
	var text := "test"
	packet.resize_buffer(buffer_size)
	packet.add_string_as_utf8(buffer_size, text)
	var _test: GdUnitAssert = assert_str(packet.buffer.get_string_from_utf8()) \
			.is_equal(text)
	var expected := LFSText.unicode_to_lfs_bytes(text)
	var _discard := expected.resize(buffer_size)
	_test = assert_array(packet.buffer).is_equal(expected)


@warning_ignore("unused_parameter")
func test_add_string_variable_length(text: String, max_length: int, step: int, test_parameters := [
	["test", 4, 4],
	["test", 24, 4],
	["test test", 24, 4],
]
) -> void:
	packet.resize_buffer(max_length)
	packet.add_string_variable_length(text, max_length, step)
	var expected := LFSText.unicode_to_lfs_bytes(text)
	var needed_size := (text.length() + step) - ((text.length() + step) % step)
	var _discard := expected.resize(mini(needed_size, max_length))
	expected[-1] = 0
	var _test: GdUnitAssert = assert_array(packet.buffer.slice(0, expected.size())) \
			.is_equal(expected)
	_test = assert_str(LFSText.lfs_bytes_to_unicode(packet.buffer)) \
			.is_equal(LFSText.lfs_bytes_to_unicode(expected))


func test_add_unsigned() -> void:
	var number := int(PI * 1_000_000)
	packet.resize_buffer(4)
	packet.add_unsigned(number)
	var buffer := PackedByteArray([0, 0, 0, 0])
	buffer.encode_u32(0, number)
	var _test := assert_array(packet.buffer).is_equal(buffer)


func test_add_word() -> void:
	var number := int(1337)
	packet.resize_buffer(2)
	packet.add_word(number)
	var buffer := PackedByteArray([0, 0])
	buffer.encode_u16(0, number)
	var _test := assert_array(packet.buffer).is_equal(buffer)


@warning_ignore("unused_parameter")
func test_read_byte(number: int, test_parameters := [
	[42],
]) -> void:
	var buffer := PackedByteArray([0])
	buffer.encode_u8(0, number)
	packet.buffer = buffer
	var _test := assert_int(packet.read_byte()).is_equal(number)


@warning_ignore("unused_parameter")
func test_read_car_name(car_name: String, test_parameters := [
	["UF1"],
	["FBM"],
	["XRT"],
	["FZ5"],
	["DBF12E"],
]) -> void:
	packet.buffer = LFSText.car_name_to_lfs_bytes(car_name)
	var _test := assert_str(packet.read_car_name()).is_equal(car_name)


@warning_ignore("unused_parameter")
func test_read_char(text: String, test_parameters := [
	["A"],
	["z"],
	["5"],
	["_"],
	["^"],
	["!"],
]) -> void:
	# Buffer sliced to keep only first character, as special characters
	# can be replaced with ^ and another character (and ^ == ^^)
	var buffer := LFSText.unicode_to_lfs_bytes(text).slice(0, 1)
	packet.buffer = buffer
	var _test := assert_str(packet.read_char()) \
			.is_equal(LFSText.lfs_bytes_to_unicode(buffer, false))


@warning_ignore("unused_parameter")
func test_read_float(number: float, test_parameters := [
	[PI * 1_000_000],
	[PI / 1_000],
]) -> void:
	var buffer := PackedByteArray([0, 0, 0, 0])
	buffer.encode_float(0, number)
	packet.buffer = buffer
	var _test := assert_float(packet.read_float()).is_equal(buffer.decode_float(0))


@warning_ignore("unused_parameter")
func test_read_int(number: int, test_parameters := [
	[int(PI * 1_000_000)],
	[42],
	[-123_456_789],
]) -> void:
	var buffer := PackedByteArray([0, 0, 0, 0])
	buffer.encode_s32(0, number)
	packet.buffer = buffer
	var _test := assert_int(packet.read_int()).is_equal(buffer.decode_s32(0))


@warning_ignore("unused_parameter")
func test_read_short(number: int, test_parameters := [
	[int(PI * 1_000_000)],
	[42],
	[-123_456_789],
]) -> void:
	var buffer := PackedByteArray([0, 0, 0, 0])
	buffer.encode_s16(0, number)
	packet.buffer = buffer
	var _test := assert_int(packet.read_short()).is_equal(buffer.decode_s16(0))


@warning_ignore("unused_parameter")
func test_read_string(text: String, test_parameters := [
	["test"],
	["Live For Speed"],
	["InSim"],
	["日本語"],
]) -> void:
	packet.buffer = LFSText.unicode_to_lfs_bytes(text)
	var _test := assert_str(packet.read_string(packet.buffer.size(), false)) \
			.is_equal(text)


@warning_ignore("unused_parameter")
func test_read_string_as_utf8(text: String, test_parameters := [
	["test"],
	["Live For Speed"],
	["InSim"],
	["日本語"],
]) -> void:
	packet.buffer = text.to_utf8_buffer()
	var _test := assert_str(packet.read_string_as_utf8(packet.buffer.size())) \
			.is_equal(text)


@warning_ignore("unused_parameter")
func test_read_unsigned(number: int, test_parameters := [
	[int(PI * 1_000_000)],
	[42],
	[-123_456_789],
]) -> void:
	var buffer := PackedByteArray([0, 0, 0, 0])
	buffer.encode_u32(0, number)
	packet.buffer = buffer
	var _test := assert_int(packet.read_unsigned()).is_equal(buffer.decode_u32(0))


@warning_ignore("unused_parameter")
func test_read_word(number: int, test_parameters := [
	[int(PI * 1_000_000)],
	[42],
	[-123_456_789],
]) -> void:
	var buffer := PackedByteArray([0, 0, 0, 0])
	buffer.encode_u16(0, number)
	packet.buffer = buffer
	var _test := assert_int(packet.read_word()).is_equal(buffer.decode_u16(0))


@warning_ignore("unused_parameter")
func test_resize_buffer(size: int, test_parameters := [
	[10],
	[0],
	[400],
]) -> void:
	var _discard := packet.buffer.resize(size)
	var _test := assert_array(packet.buffer).has_size(size)
