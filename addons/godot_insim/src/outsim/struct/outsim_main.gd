class_name OutSimMain
extends RefCounted
## Main OutSim data
##
## This class contains the main OutSim data, which is more or less equivalent to the base LFS
## OutSimPack.

const STRUCT_SIZE := 60  ## The size of the contained data.
const POSITION_MULTIPLIER := 65536.0  ## Conversion factor between SI units and LFS-encoded values.

var ang_vel := Vector3.ZERO  ## Angular velocity in m/s
var heading := 0.0  ## Heading in radians
var pitch := 0.0  ## Pitch in radians
var roll := 0.0  ## Roll in radians
var accel := Vector3.ZERO  ## Acceleration in m/s^2
var vel := Vector3.ZERO  ## Velocity in m/s
var pos := Vector3i.ZERO  ## Position in LFS-encoded values

var gis_position := Vector3.ZERO  ## Position in meters
## Vector containing [member pitch], [member roll], and [member heading].
var gis_angles := Vector3.ZERO


func _to_string() -> String:
	return "AngVel:%v, Heading:%f, Pitch:%f, Roll:%f, Accel:%v, Vel:%v, Pos:%v" % [
		ang_vel, heading, pitch, roll, accel, vel, pos
	]


## Returns the buffer corresponding to the current data.
func get_buffer() -> PackedByteArray:
	var buffer := PackedByteArray()
	var _discard := buffer.resize(STRUCT_SIZE)
	buffer.encode_float(0, ang_vel.x)
	buffer.encode_float(4, ang_vel.y)
	buffer.encode_float(8, ang_vel.z)
	buffer.encode_float(12, heading)
	buffer.encode_float(16, pitch)
	buffer.encode_float(20, roll)
	buffer.encode_float(24, accel.x)
	buffer.encode_float(28, accel.y)
	buffer.encode_float(32, accel.z)
	buffer.encode_float(36, vel.x)
	buffer.encode_float(40, vel.y)
	buffer.encode_float(44, vel.z)
	buffer.encode_u32(48, pos.x)
	buffer.encode_u32(52, pos.y)
	buffer.encode_u32(56, pos.z)
	return buffer


func get_dictionary() -> Dictionary:
	return {
		"AngVel": ang_vel,
		"Heading": heading,
		"Pitch": pitch,
		"Roll": roll,
		"Accel": accel,
		"Vel": vel,
		"Pos": pos,
	}


## Sets the properties' values from the given [param buffer].
func set_from_buffer(buffer: PackedByteArray) -> void:
	var buffer_size := buffer.size()
	if buffer_size != STRUCT_SIZE:
		push_error("Wrong buffer size, expected %d, got %d" % [STRUCT_SIZE, buffer_size])
		return
	ang_vel = Vector3(buffer.decode_float(0), buffer.decode_float(4), buffer.decode_float(8))
	heading = buffer.decode_float(12)
	pitch = buffer.decode_float(16)
	roll = buffer.decode_float(20)
	accel = Vector3(buffer.decode_float(24), buffer.decode_float(28), buffer.decode_float(32))
	vel = Vector3(buffer.decode_float(36), buffer.decode_float(40), buffer.decode_float(44))
	pos = Vector3i(buffer.decode_u32(48), buffer.decode_u32(52), buffer.decode_u32(56))
	gis_position = pos / POSITION_MULTIPLIER
	gis_angles = Vector3(pitch, roll, heading)


func set_from_dictionary(dict: Dictionary) -> void:
	if not dict.has_all(["AngVel", "Heading", "Pitch", "Roll", "Accel", "Vel", "Pos"]):
		push_error("Cannot set data from dictionary: missing keys")
		return
	ang_vel = dict["AngVel"]
	heading = dict["Heading"]
	pitch = dict["Pitch"]
	roll = dict["Roll"]
	accel = dict["Accel"]
	vel = dict["Vel"]
	pos = dict["Pos"]
