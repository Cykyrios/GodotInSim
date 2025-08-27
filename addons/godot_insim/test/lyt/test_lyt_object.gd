extends GdUnitTestSuite

# TestSuite generated from
const __source = "res://addons/godot_insim/src/lyt/lyt_file.gd"


@warning_ignore("unused_parameter")
func test_create_from_object_info(object: ObjectInfo, test_parameters := [
	[ObjectInfo.create(0, 0, 128, 255, 0, InSim.AXOIndex.AXO_CHALK_LINE)],
	[ObjectInfo.create(-1234, 1234, 42, 10, 0x80, InSim.AXOIndex.AXO_TYRE_STACK3)],
	[ObjectInfo.create(-1234, 1234, 42, 10, 12, InSim.AXOIndex.AXO_IS_AREA)],
]) -> void:
	var lyt_object := LYTObject.create_from_object_info(object)
	var _test := assert_array(lyt_object.get_buffer()).is_equal(object.get_buffer())


func test_create_object_from_buffer() -> void:
	var _test := assert_object(LYTObject.create_from_buffer(
		PackedByteArray([0, 0, 0, 0, 0, 0, InSim.AXOIndex.AXO_CHALK_LINE, 0])
	)).is_instanceof(LYTObjectChalk)
	_test = assert_object(LYTObject.create_from_buffer(
		PackedByteArray([0, 0, 0, 0, 0, 0, InSim.AXOIndex.AXO_TYRE_STACK3, 0])
	)).is_instanceof(LYTObjectTyre)
	_test = assert_object(LYTObject.create_from_buffer(
		PackedByteArray([0, 0, 0, 0, 0, 0, InSim.AXOIndex.AXO_CONCRETE_SLAB, 0])
	)).is_instanceof(LYTObjectConcrete)
	_test = assert_object(LYTObject.create_from_buffer(
		PackedByteArray([0, 0, 0, 0, 0, 0, InSim.AXOIndex.AXO_START_POSITION, 0])
	)).is_instanceof(LYTObjectStart)
	_test = assert_object(LYTObject.create_from_buffer(
		PackedByteArray([0, 0, 0, 0, 0, 0, InSim.AXOIndex.AXO_IS_CP, 0])
	)).is_instanceof(LYTObjectCheckpoint)
	_test = assert_object(LYTObject.create_from_buffer(
		PackedByteArray([0, 0, 0, 0, 0, 0, InSim.AXOIndex.AXO_IS_AREA, 0])
	)).is_instanceof(LYTObjectCircle)
	_test = assert_object(LYTObject.create_from_buffer(
		PackedByteArray([0, 0, 0, 0, 0, 0, InSim.AXOIndex.AXO_MARSHAL, 0])
	)).is_instanceof(LYTObjectMarshal)
	_test = assert_object(LYTObject.create_from_buffer(
		PackedByteArray([0, 0, 0, 0, 0, 0, InSim.AXOIndex.AXO_ROUTE, 0])
	)).is_instanceof(LYTObjectRoute)
