extends GdUnitTestSuite

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/struct/player_handicap.gd"

var params := [
	[
		PackedByteArray([1, 3, 55, 30]),
		1, 3, 55, 30,
	],
]
var epsilon := 1e-5


@warning_ignore("unused_parameter")
func test_buffer_to_struct(
	buffer: PackedByteArray, plid: int, flags: int, h_mass: int, h_tres: int,
	test_parameters := params
) -> void:
	var struct := PlayerHandicap.new()
	struct.set_from_buffer(buffer)
	var _test: GdUnitAssert = assert_int(struct.plid).is_equal(plid)
	_test = assert_int(struct.flags).is_equal(flags)
	_test = assert_int(struct.h_mass).is_equal(h_mass)
	_test = assert_int(struct.h_tres).is_equal(h_tres)
	_test = assert_float(struct.gis_mass).is_equal_approx(
		struct.h_mass / PlayerHandicap.MASS_MULTIPLIER, epsilon
	)


@warning_ignore("unused_parameter")
func test_struct_to_buffer(
	buffer: PackedByteArray, plid: int, flags: int, h_mass: int, h_tres: int,
	test_parameters := params
) -> void:
	var struct := PlayerHandicap.create(
		plid,
		flags,
		h_mass,
		h_tres
	)
	var _test := assert_array(struct.get_buffer()).is_equal(buffer)


@warning_ignore("unused_parameter")
func test_gis_struct_to_buffer(
	buffer: PackedByteArray, plid: int, flags: int, h_mass: int, h_tres: int,
	test_parameters := params
) -> void:
	var struct := PlayerHandicap.create_from_gis_values(
		plid,
		flags,
		h_mass / PlayerHandicap.MASS_MULTIPLIER,
		h_tres
	)
	var _test := assert_array(struct.get_buffer(true)).is_equal(buffer)
