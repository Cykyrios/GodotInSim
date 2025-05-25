class_name PTHNode
extends RefCounted

## PTH Node
##
## This class contains data about each path node contained in a [PTHFile].

## Conversion factor between SI units and LFS-encoded values.
const POSITION_MULTIPLIER := 65536.0
## Data size for a [PTHNode].
const STRUCT_SIZE := 40

## Node center x component.
var center_x := 0
## Node center y component.
var center_y := 0
## Node center z component.
var center_z := 0
## Node direction x component.
var dir_x := 0.0
## Node direction y component.
var dir_y := 0.0
## Node direction z component.
var dir_z := 0.0
## Left overall limit.
var limit_left := 0.0
## Right overall limit.
var limit_right := 0.0
## Left driving area limit.[br]
## [b]Note:[/b] Official PTH files may not follow actual track limits, some corners exclude part of
## the track limits area, while others go well beyond the white lines.
var drive_left := 0.0
## Right driving area limit.[br]
## [b]Note:[/b] Official PTH files may not follow actual track limits, some corners exclude part of
## the track limits area, while others go well beyond the white lines.
var drive_right := 0.0

## The node's reference point, typically found on the racing line.
var center := Vector3.ZERO
## The node's front-facing vector.
var direction := Vector3.ZERO
## The node's transform, as defined by [member center] and [member direction].
var xform := Transform3D.IDENTITY


func _to_string() -> String:
	return "Center: %v, Direction: %.2v, Limits: %.2v, Drive: %.2v" % [
		Vector3i(center_x, center_y, center_z),
		Vector3(dir_x, dir_y, dir_z),
		Vector2(limit_left, limit_right),
		Vector2(drive_left, drive_right),
	]


## Creates and returns a new [PTHNode] from the given [param buffer].
static func create_from_buffer(buffer: PackedByteArray) -> PTHNode:
	var node := PTHNode.new()
	node.decode_buffer(buffer)
	return node


## Decodes the given [param buffer] and fills the [PTHNode]'s properties.
func decode_buffer(buffer: PackedByteArray) -> void:
	if buffer.size() != STRUCT_SIZE:
		push_error("Wrong size for PTHNode: got %d, expected %d" % [buffer.size(), STRUCT_SIZE])
		return
	var packet := LFSPacket.create_packet_from_buffer(buffer)
	center_x = packet.read_int()
	center_y = packet.read_int()
	center_z = packet.read_int()
	dir_x = packet.read_float()
	dir_y = packet.read_float()
	dir_z = packet.read_float()
	limit_left = packet.read_float()
	limit_right = packet.read_float()
	drive_left = packet.read_float()
	drive_right = packet.read_float()

	center = Vector3(center_x, center_y, center_z) / POSITION_MULTIPLIER
	direction = Vector3(dir_x, dir_y, dir_z)
	xform.origin = center
	var basis_y := direction.normalized()
	var basis_x := basis_y.cross(Vector3(0, 0, 1)).normalized()
	var basis_z := basis_x.cross(basis_y).normalized()
	xform.basis = Basis(basis_x, basis_y, basis_z).orthonormalized()
