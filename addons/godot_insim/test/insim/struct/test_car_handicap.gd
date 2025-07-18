extends GdUnitTestSuite

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/struct/car_handicap.gd"


var params := [
	[
		PackedByteArray([55, 30]),
		55, 30,
	],
]
var epsilon := 1e-5

@warning_ignore("unused_parameter")
func test_buffer_to_struct(
	buffer: PackedByteArray, h_mass: int, h_tres: int, test_parameters := params
) -> void:
	var struct := CarHandicap.new()
	struct.set_from_buffer(buffer)
	var _test: GdUnitAssert = assert_int(struct.h_mass).is_equal(h_mass)
	_test = assert_int(struct.h_tres).is_equal(h_tres)
	_test = assert_float(struct.gis_mass).is_equal_approx(
		struct.h_mass / CarHandicap.MASS_MULTIPLIER, epsilon
	)


@warning_ignore("unused_parameter")
func test_struct_to_buffer(
	buffer: PackedByteArray, h_mass: int, h_tres: int, test_parameters := params
) -> void:
	var struct := CarHandicap.create(h_mass, h_tres)
	var _test := assert_array(struct.get_buffer()).is_equal(buffer)


@warning_ignore("unused_parameter")
func test_gis_struct_to_buffer(
	buffer: PackedByteArray, h_mass: int, h_tres: int, test_parameters := params
) -> void:
	var struct := CarHandicap.create_from_gis_values(h_mass / CarHandicap.MASS_MULTIPLIER, h_tres)
	var _test := assert_array(struct.get_buffer(true)).is_equal(buffer)
