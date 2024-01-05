class_name OutSimWheel
extends RefCounted


const STRUCT_SIZE := 40

var susp_deflect := 0.0
var steer := 0.0
var x_force := 0.0
var y_force := 0.0
var vertical_load := 0.0
var ang_vel := 0.0
var lean_rel_to_road := 0.0

var air_temp := 0
var slip_fraction := 0
var touching := 0
var sp3 := 0

var slip_ratio := 0.0
var tan_slip_angle := 0.0


func _to_string() -> String:
	return "SuspDeflect:%f, Steer:%f, XForce:%f, YForce:%f, VerticalLoad:%f, AngVel:%f, LeanRelToRoad:%f" % \
			[susp_deflect, steer, x_force, y_force, vertical_load, ang_vel, lean_rel_to_road] \
			+ ", AirTemp:%f, SlipFraction:%f, Touching:%f, Sp3:%f, SlipRatio:%f, TanSlipAngle:%f" % \
			[air_temp, slip_fraction, touching, sp3, slip_ratio, tan_slip_angle]


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
