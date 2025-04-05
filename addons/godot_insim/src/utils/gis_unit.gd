class_name GISUnit
extends RefCounted


enum Acceleration {METER_PER_SECOND_SQUARED, G}
enum Angle {RADIAN, DEGREE}
enum Force {NEWTON}
enum Length {METER, KILOMETER, CENTIMETER, MILLIMETER, MILE, INCH}
enum Mass {KILOGRAM, TONNE, POUND}
enum Power {WATT}
enum Speed {METER_PER_SECOND, KPH, MPH}
enum Duration {SECOND, MILLISECOND, MINUTE, HOUR}

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
	39.370_078_74,
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


static func convert_acceleration(value: float, from: Acceleration, to: Acceleration) -> float:
	return value / ACCELERATIONS[from] * ACCELERATIONS[to]


static func convert_angle(value: float, from: Angle, to: Angle) -> float:
	return value / ANGLES[from] * ANGLES[to]


static func convert_force(value: float, from: Force, to: Force) -> float:
	return value / FORCES[from] * FORCES[to]


static func convert_length(value: float, from: Length, to: Length) -> float:
	return value / LENGTHS[from] * LENGTHS[to]


static func convert_mass(value: float, from: Mass, to: Mass) -> float:
	return value / MASSES[from] * MASSES[to]


static func convert_power(value: float, from: Power, to: Power) -> float:
	return value / POWERS[from] * POWERS[to]


static func convert_speed(value: float, from: Speed, to: Speed) -> float:
	return value / SPEEDS[from] * SPEEDS[to]


static func convert_duration(value: float, from: Duration, to: Duration) -> float:
	return value / TIMES[from] * TIMES[to]
