extends GdUnitTestSuite

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/struct/ip_address.gd"

@warning_ignore("unused_parameter")
func test_ip_int_to_string(value: int, text: String, test_parameters := [
	[123456, "64.226.1.0"],
	[0xffff_ffff, "255.255.255.255"],
	[0xaa99_ccee, "238.204.153.170"],
	[0x0055_aaff, "255.170.85.0"],
	[0, "0.0.0.0"],
	[0x0102_0304, "4.3.2.1"],
	[-42, "0.0.0.0"],
	[0xff_ffff_ffff, "0.0.0.0"],
]) -> void:
	var ip := IPAddress.new()
	ip.fill_from_int(value)
	var _test := assert_str(ip.address_string).is_equal(text)


@warning_ignore("unused_parameter")
func test_ip_string_to_int(text: String, value: int, test_parameters := [
	["192.168.1.2", 33_663_168],
	["192.168.1.2", 0x0201_a8c0],
	["0.0.0.0", 0x0000_0000],
	["255.255.255.255", 0xffff_ffff],
	["-10.1337.42.128", 0x802a_0000],
]) -> void:
	var ip := IPAddress.new()
	ip.fill_from_string(text)
	var _test := assert_int(ip.address_int).is_equal(value)


@warning_ignore("unused_parameter")
func test_ip_int_to_array(value: int, array: PackedByteArray, test_parameters := [
	[123456, PackedByteArray([64, 226, 1, 0])],
	[0xffff_ffff, PackedByteArray([255, 255, 255, 255])],
	[0xaa99_ccee, PackedByteArray([238, 204, 153, 170])],
	[0x0055_aaff, PackedByteArray([255, 170, 85, 0])],
	[0, PackedByteArray([0, 0, 0, 0])],
	[0x0102_0304, PackedByteArray([4, 3, 2, 1])],
	[-42, PackedByteArray([0, 0, 0, 0])],
	[0xff_ffff_ffff, PackedByteArray([0, 0, 0, 0])],
]) -> void:
	var ip := IPAddress.new()
	ip.fill_from_int(value)
	var _test := assert_array(ip.address_array).is_equal(array)


@warning_ignore("unused_parameter")
func test_ip_array_to_int(array: PackedByteArray, value: int, test_parameters := [
	[PackedByteArray([192, 168, 1, 2]), 0x0201_a8c0],
	[PackedByteArray([0, 0, 0, 0]), 0x0000_0000],
	[PackedByteArray([255, 255, 255, 255]), 0xffff_ffff],
	[PackedByteArray([-10, 1337, 42, 128]), 0x802a_39f6],
]) -> void:
	var ip := IPAddress.new()
	ip.fill_from_array(array)
	var _test := assert_int(ip.address_int).is_equal(value)


@warning_ignore("unused_parameter")
func test_ip_string_to_array(text: String, array: PackedByteArray, test_parameters := [
	["192.168.1.2", PackedByteArray([192, 168, 1, 2])],
	["0.0.0.0", PackedByteArray([0, 0, 0, 0])],
	["255.255.255.255", PackedByteArray([255, 255, 255, 255])],
	["-10.1337.42.128", PackedByteArray([00, 0, 42, 128])],
]) -> void:
	var ip := IPAddress.new()
	ip.fill_from_string(text)
	var _test := assert_array(ip.address_array).is_equal(array)


@warning_ignore("unused_parameter")
func test_ip_array_to_string(array: PackedByteArray, text: String, test_parameters := [
	[PackedByteArray([192, 168, 1, 2]), "192.168.1.2"],
	[PackedByteArray([0, 0, 0, 0]), "0.0.0.0"],
	[PackedByteArray([255, 255, 255, 255]), "255.255.255.255"],
	[PackedByteArray([-10, 1337, 42, 128]), "246.57.42.128"],
]) -> void:
	var ip := IPAddress.new()
	ip.fill_from_array(array)
	var _test := assert_str(ip.address_string).is_equal(text)
