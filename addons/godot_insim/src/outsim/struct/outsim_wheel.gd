class_name OutSimWheel
extends RefCounted
## OutSim wheel data
##
## This class contains detailed data about individual wheels.

const STRUCT_SIZE := 40  ## The size of this data struct

var susp_deflect := 0.0  ## Current suspension deflection in meters, compression is positive.
## Current steering angle, including toe and parallel steering effect, positive when turning left.
var steer := 0.0
var x_force := 0.0  ## Lateral force at the contact patch, in N, positive to the right.
var y_force := 0.0  ## Longitudinal force at the contact patch, in N, positive forward.
var vertical_load := 0.0  ## Vertical load on the wheel, in N.
var ang_vel := 0.0  ## Angular velocity of the wheel in rad/s, positive when driving forward.
## Current leaning angle, including camber, road inclination, and car angles.
var lean_rel_to_road := 0.0

var air_temp := 0  ## Air temperature inside the tyre
var slip_fraction := 0  ## Slip fraction as a byte (0-255)
var touching := 0  ## Whether the wheel is touching the ground (1 if true, 0 if false).
var sp3 := 0  ## Spare byte

var slip_ratio := 0.0  ## Slip ratio (can go over 1.0)
var tan_slip_angle := 0.0  ## Tangent of the slip angle


func _to_string() -> String:
	return "SuspDeflect:%f, Steer:%f, XForce:%f, YForce:%f, VerticalLoad:%f" % [
		susp_deflect, steer, x_force, y_force, vertical_load
	] + ", AngVel:%f, LeanRelToRoad:%f, AirTemp:%f, SlipFraction:%f, Touching:%f" % [
		ang_vel, lean_rel_to_road, air_temp, slip_fraction, touching
	] + ", SlipRatio:%f, TanSlipAngle:%f" % [
		slip_ratio, tan_slip_angle
	]


## Sets the properties from the given [param buffer].
func set_from_buffer(buffer: PackedByteArray) -> void:
	var buffer_size := buffer.size()
	if buffer_size != STRUCT_SIZE:
		push_error("Wrong buffer size, expected %d, got %d" % [STRUCT_SIZE, buffer_size])
		return
	susp_deflect = buffer.decode_float(0)
	steer = buffer.decode_float(4)
	x_force = buffer.decode_float(8)
	y_force = buffer.decode_float(12)
	vertical_load = buffer.decode_float(16)
	ang_vel = buffer.decode_float(20)
	lean_rel_to_road = buffer.decode_float(24)
	air_temp = buffer.decode_u8(28)
	slip_fraction = buffer.decode_u8(29)
	touching = buffer.decode_u8(30)
	sp3 = buffer.decode_u8(31)
	slip_ratio = buffer.decode_float(32)
	tan_slip_angle = buffer.decode_float(36)
