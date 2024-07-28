extends GutTest


var params_ip_int_to_string := [
	[123456, "64.226.1.0"],
	[0xffff_ffff, "255.255.255.255"],
	[0xaa99_ccee, "238.204.153.170"],
	[0x0055_aaff, "255.170.85.0"],
	[0, "0.0.0.0"],
	[0x0102_0304, "4.3.2.1"],
	[-42, "0.0.0.0"],
	[0xff_ffff_ffff, "0.0.0.0"],
]
func test_ip_int_to_string(params: Array = use_parameters(params_ip_int_to_string)) -> void:
	var ip := IPAddress.new()
	ip.fill_from_int(params[0] as int)
	assert_eq(ip.address_string, params[1] as String)


var params_ip_string_to_int := [
	["192.168.1.2", 33_663_168],
	["192.168.1.2", 0x0201_a8c0],
	["0.0.0.0", 0x0000_0000],
	["255.255.255.255", 0xffff_ffff],
	["-10.1337.42.128", 0x802a_0000],
]
func test_ip_string_to_int(params: Array = use_parameters(params_ip_string_to_int)) -> void:
	var ip := IPAddress.new()
	ip.fill_from_string(params[0] as String)
	assert_eq(ip.address_int, params[1] as int)


var params_ip_int_to_array := [
	[123456, PackedByteArray([64, 226, 1, 0])],
	[0xffff_ffff, PackedByteArray([255, 255, 255, 255])],
	[0xaa99_ccee, PackedByteArray([238, 204, 153, 170])],
	[0x0055_aaff, PackedByteArray([255, 170, 85, 0])],
	[0, PackedByteArray([0, 0, 0, 0])],
	[0x0102_0304, PackedByteArray([4, 3, 2, 1])],
	[-42, PackedByteArray([0, 0, 0, 0])],
	[0xff_ffff_ffff, PackedByteArray([0, 0, 0, 0])],
]
func test_ip_int_to_array(params: Array = use_parameters(params_ip_int_to_array)) -> void:
	var ip := IPAddress.new()
	ip.fill_from_int(params[0] as int)
	assert_eq(ip.address_array, params[1] as PackedByteArray)


var params_ip_array_to_int := [
	[PackedByteArray([192, 168, 1, 2]), 0x0201_a8c0],
	[PackedByteArray([0, 0, 0, 0]), 0x0000_0000],
	[PackedByteArray([255, 255, 255, 255]), 0xffff_ffff],
	[PackedByteArray([-10, 1337, 42, 128]), 0x802a_39f6],
]
func test_ip_array_to_int(params: Array = use_parameters(params_ip_array_to_int)) -> void:
	var ip := IPAddress.new()
	ip.fill_from_array(params[0] as PackedByteArray)
	assert_eq(ip.address_int, params[1] as int)


var params_ip_string_to_array := [
	["192.168.1.2", PackedByteArray([192, 168, 1, 2])],
	["0.0.0.0", PackedByteArray([0, 0, 0, 0])],
	["255.255.255.255", PackedByteArray([255, 255, 255, 255])],
	["-10.1337.42.128", PackedByteArray([00, 0, 42, 128])],
]
func test_ip_string_to_array(params: Array = use_parameters(params_ip_string_to_array)) -> void:
	var ip := IPAddress.new()
	ip.fill_from_string(params[0] as String)
	assert_eq(ip.address_array, params[1] as PackedByteArray)


var params_ip_array_to_string := [
	[PackedByteArray([192, 168, 1, 2]), "192.168.1.2"],
	[PackedByteArray([0, 0, 0, 0]), "0.0.0.0"],
	[PackedByteArray([255, 255, 255, 255]), "255.255.255.255"],
	[PackedByteArray([-10, 1337, 42, 128]), "246.57.42.128"],
]
func test_ip_array_to_string(params: Array = use_parameters(params_ip_array_to_string)) -> void:
	var ip := IPAddress.new()
	ip.fill_from_array(params[0] as PackedByteArray)
	assert_eq(ip.address_string, params[1] as String)
