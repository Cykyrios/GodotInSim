class_name PTHNode
extends RefCounted

## PTH Node
##
## This class contains data about each path node contained in a [PTHFile].

const POSITION_MULTIPLIER := 65536.0

const STRUCT_SIZE := 40

var center_x := 0
var center_y := 0
var center_z := 0
var dir_x := 0.0
var dir_y := 0.0
var dir_z := 0.0
var limit_left := 0.0
var limit_right := 0.0
var drive_left := 0.0
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


static func create_from_buffer(buffer: PackedByteArray) -> PTHNode:
	var node := PTHNode.new()
	node.decode_buffer(buffer)
	return node


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
