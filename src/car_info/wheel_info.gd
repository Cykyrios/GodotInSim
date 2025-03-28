class_name WheelInfo
extends RefCounted

## Wheel Info
##
## This class describes a wheel and suspension's complete characteristics, as part of the
## [CarInfo] object.

const STRUCT_SIZE := 128

var tyre_type := InSim.Tyre.TYRE_R1
var tyre_pressure := 200.0
var tyre_temperature := 20.0
var toe_in := 0.0

var contact_patch_center := Vector3.ZERO
var unsprung_mass := 0.0

var tyre_width := 0.0
var tyre_ratio := 0.0
var rim_radius := 0.0
var rim_width := 0.0

var spring_constant := 0.0
var damping_bump := 0.0
var damping_rebound := 0.0
var anti_roll := 0.0

var camber := 0.0
var inclination := 0.0
var caster := 0.0
var scrub_radius := 0.0

var moment_of_inertia := 0.0
var deflection_current := 0.0
var deflection_max := 0.0

var tyre_spring_constant_current := 0.0
var tyre_deflection_current := 0.0


static func create_from_buffer(buffer: PackedByteArray) -> WheelInfo:
	var wheel := WheelInfo.new()
	if buffer.size() != STRUCT_SIZE:
		print("Wrong buffer size for WheelInfo: expected %d, got %d" % [STRUCT_SIZE, buffer.size()])
		return wheel
	wheel.tyre_type = buffer.decode_u8(0) as InSim.Tyre
	wheel.tyre_pressure = buffer.decode_float(4)
	wheel.tyre_temperature = buffer.decode_float(8)
	wheel.toe_in = buffer.decode_float(12)
	wheel.contact_patch_center = Vector3(
		buffer.decode_float(16),
		buffer.decode_float(20),
		buffer.decode_float(24)
	)
	wheel.unsprung_mass = buffer.decode_float(28)
	wheel.tyre_width = buffer.decode_float(32)
	wheel.tyre_ratio = buffer.decode_float(36)
	wheel.rim_radius = buffer.decode_float(40)
	wheel.rim_width = buffer.decode_float(44)
	wheel.spring_constant = buffer.decode_float(48)
	wheel.damping_bump = buffer.decode_float(52)
	wheel.damping_rebound = buffer.decode_float(56)
	wheel.anti_roll = buffer.decode_float(60)
	wheel.camber = buffer.decode_float(64)
	wheel.inclination = buffer.decode_float(68)
	wheel.caster = buffer.decode_float(72)
	wheel.scrub_radius = buffer.decode_float(76)
	wheel.moment_of_inertia = buffer.decode_float(80)
	wheel.deflection_current = buffer.decode_float(84)
	wheel.deflection_max = buffer.decode_float(88)
	wheel.tyre_spring_constant_current = buffer.decode_float(96)
	wheel.tyre_deflection_current = buffer.decode_float(100)
	return wheel


func get_tyre_width() -> int:
	return roundi(tyre_width * 1000)


func get_tyre_ratio() -> int:
	return roundi(tyre_ratio * 100)


func get_rim_diameter_inch() -> int:
	return roundi(GISUtils.convert_length(
		rim_radius * 2,
		GISUtils.LengthUnit.METER,
		GISUtils.LengthUnit.INCH
	))


func get_rim_width_inch() -> float:
	return snappedf(GISUtils.convert_length(
		rim_width,
		GISUtils.LengthUnit.METER,
		GISUtils.LengthUnit.INCH
	), 0.25)
