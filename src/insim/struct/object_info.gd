class_name ObjectInfo
extends InSimStruct


const POSITION_MULTIPLIER := 16.0
const Z_MULTIPLIER := 4.0
const ANGLE_MULTIPLIER := 256 / 360.0

const STRUCT_SIZE := 8

var x := 0  ## position (1 metre = 16)
var y := 0  ## position (1 metre = 16)

var z := 0  ## height (1m = 4)
var flags := 0  ## various (see LFS LYT format description)
var index := 0  ## object index
var heading := 0  ## (degrees + 180) * 256 / 360

var gis_position := Vector3.ZERO
var gis_heading := 0.0


func _to_string() -> String:
	return "X:%d, Y:%d, Z:%d, Flags:%d, Index:%d, Heading:%d" % [x, y, z, flags, index, heading]


func _get_buffer() -> PackedByteArray:
	var buffer := PackedByteArray()
	var _discard := buffer.resize(STRUCT_SIZE)
	buffer.encode_s16(0, x)
	buffer.encode_s16(2, y)
	buffer.encode_u8(4, z)
	buffer.encode_u8(5, flags)
	buffer.encode_u8(6, index)
	buffer.encode_u8(7, heading)
	return buffer


func _set_from_buffer(buffer: PackedByteArray) -> void:
	if buffer.size() != STRUCT_SIZE:
		push_error("Wrong buffer size, expected %d, got %d" % [STRUCT_SIZE, buffer.size()])
	x = buffer.decode_u16(0)
	y = buffer.decode_u16(2)
	z = buffer.decode_u8(4)
	flags = buffer.decode_u8(5)
	index = buffer.decode_u8(6)
	heading = buffer.decode_u8(7)


func _set_values_from_gis() -> void:
	x = int(gis_position.x * POSITION_MULTIPLIER)
	y = int(gis_position.y * POSITION_MULTIPLIER)
	z = int(gis_position.z * Z_MULTIPLIER)
	heading = int((180 + rad_to_deg(gis_heading)) * ANGLE_MULTIPLIER)


func _update_gis_values() -> void:
	gis_position = Vector3(x / POSITION_MULTIPLIER, y / POSITION_MULTIPLIER, z / Z_MULTIPLIER)
	gis_heading = deg_to_rad(heading / ANGLE_MULTIPLIER - 180)
