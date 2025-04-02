class_name AeroInfo
extends RefCounted

## Aero Info
##
## This class describes an aero object (rear wing, front wing, undertray or main body), as part
## of the [CarInfo] object.

const STRUCT_SIZE := 20

var position := Vector3.ZERO
var lift := 0.0
var drag := 0.0


static func create_from_buffer(buffer: PackedByteArray) -> AeroInfo:
	var aero := AeroInfo.new()
	if buffer.size() != STRUCT_SIZE:
		print("Wrong buffer size for AeroInfo: expected %d, got %d" % [STRUCT_SIZE, buffer.size()])
		return aero
	aero.position = Vector3(
		buffer.decode_float(0),
		buffer.decode_float(4),
		buffer.decode_float(8)
	)
	aero.lift = buffer.decode_float(12)
	aero.drag = buffer.decode_float(16)
	return aero
