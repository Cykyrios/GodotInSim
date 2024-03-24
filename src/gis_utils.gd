class_name GISUtils
extends RefCounted


enum AccelerationUnit {METER_PER_SECOND_SQUARED, G}
enum AngleUnit {RADIAN, DEGREE}
enum ForceUnit {NEWTON}
enum LengthUnit {METER, KILOMETER, CENTIMETER, MILLIMETER, MILE}
enum MassUnit {KILOGRAM, TONNE, POUND}
enum PowerUnit {WATT}
enum SpeedUnit {METER_PER_SECOND, KPH, MPH}
enum TimeUnit {SECOND, MILLISECOND, MINUTE, HOUR}

const ACCELERATIONS: Array[float] = [
	1.0,
	1 / 9.81,
]
const ANGLES: Array[float] = [
	1.0,
	180 / PI,
]
const FORCES: Array[float] = [
	1.0,
]
const LENGTHS: Array[float] = [
	1.0,
	0.001,
	100.0,
	1000.0,
	0.000_621_371_192_2,
]
const MASSES: Array[float] = [
	1.0,
	0.001,
	2.204_622_622,
]
const POWERS: Array[float] = [
	1.0,
]
const SPEEDS: Array[float] = [
	1.0,
	3.6,
	2.236_936_292,
]
const TIMES: Array[float] = [
	1.0,
	1000.0,
	1 / 60.0,
	1 / 3600.0,
]


static func convert_acceleration(value: float, from: AccelerationUnit, to: AccelerationUnit) -> float:
	return value / ACCELERATIONS[from] * ACCELERATIONS[to]


static func convert_angle(value: float, from: AngleUnit, to: AngleUnit) -> float:
	return value / ANGLES[from] * ANGLES[to]


static func convert_force(value: float, from: ForceUnit, to: ForceUnit) -> float:
	return value / FORCES[from] * FORCES[to]


static func convert_length(value: float, from: LengthUnit, to: LengthUnit) -> float:
	return value / LENGTHS[from] * LENGTHS[to]


static func convert_mass(value: float, from: MassUnit, to: MassUnit) -> float:
	return value / MASSES[from] * MASSES[to]


static func convert_power(value: float, from: PowerUnit, to: PowerUnit) -> float:
	return value / POWERS[from] * POWERS[to]


static func convert_speed(value: float, from: SpeedUnit, to: SpeedUnit) -> float:
	return value / SPEEDS[from] * SPEEDS[to]


static func convert_time(value: float, from: TimeUnit, to: TimeUnit) -> float:
	return value / TIMES[from] * TIMES[to]
