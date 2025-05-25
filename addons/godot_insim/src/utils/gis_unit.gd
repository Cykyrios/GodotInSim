class_name GISUnit
extends RefCounted
## GISUnit - Utility functions for unit conversion
##
## This class provides a number of functions that allow converting dimensions from a given unit
## to another, e.g. speeds from km/h to m/s. Each dimension has an enum and a constant array of
## conversion ratios from the SI unit (base or derived unit) to the selected one.

## Acceleration units
enum Acceleration {
	METER_PER_SECOND_SQUARED,  ## SI unit: m/s^2
	G,  ## 1 g = 9.81 m/s^2
}
## Angle units
enum Angle {
	RADIAN,  ## Radians
	DEGREE,  ## Degrees
}
## Force units
enum Force {
	NEWTON,  ## SI unit: N
}
## Length units
enum Length {
	METER,  ## SI unit: m
	KILOMETER,  ## km
	CENTIMETER,  ## cm
	MILLIMETER,  ## mm
	MILE,  ## mi
	INCH,  ## " (in)
}
## Mass units
enum Mass {
	KILOGRAM,  ## kg
	TONNE,  ## Metric ton
	POUND,  ## lb
}
## Power units
enum Power {
	WATT, ## SI unit: W
}
## Speed units
enum Speed {
	METER_PER_SECOND,  ## SI unit: m/s
	KPH,  ## km/h
	MPH,  ## mph
}
## Duration units
enum Duration {
	SECOND,  ## SI unit: s
	MILLISECOND,  ## ms
	MINUTE,  ## min
	HOUR,  ## h
}

## The list of acceleration conversion values, based on [enum Acceleration].
const ACCELERATIONS: Array[float] = [
	1.0,
	1 / 9.81,
]
## The list of angle conversion values, based on [enum Angle].
const ANGLES: Array[float] = [
	1.0,
	180 / PI,
]
## The list of force conversion values, based on [enum Force].
const FORCES: Array[float] = [
	1.0,
]
## The list of length conversion values, based on [enum Length].
const LENGTHS: Array[float] = [
	1.0,
	0.001,
	100.0,
	1000.0,
	0.000_621_371_192_2,
	39.370_078_74,
]
## The list of mass conversion values, based on [enum Mass].
const MASSES: Array[float] = [
	1.0,
	0.001,
	2.204_622_622,
]
## The list of power conversion values, based on [enum Power].
const POWERS: Array[float] = [
	1.0,
]
## The list of speed conversion values, based on [enum Speed].
const SPEEDS: Array[float] = [
	1.0,
	3.6,
	2.236_936_292,
]
## The list of duration conversion values, based on [enum Duration].
const DURATIONS: Array[float] = [
	1.0,
	1000.0,
	1 / 60.0,
	1 / 3600.0,
]


## Converts an acceleration [param value] between units [param from] and [param to].
static func convert_acceleration(value: float, from: Acceleration, to: Acceleration) -> float:
	return value / ACCELERATIONS[from] * ACCELERATIONS[to]


## Converts an angle [param value] between units [param from] and [param to].
static func convert_angle(value: float, from: Angle, to: Angle) -> float:
	return value / ANGLES[from] * ANGLES[to]


## Converts a force [param value] between units [param from] and [param to].
static func convert_force(value: float, from: Force, to: Force) -> float:
	return value / FORCES[from] * FORCES[to]


## Converts a length [param value] between units [param from] and [param to].
static func convert_length(value: float, from: Length, to: Length) -> float:
	return value / LENGTHS[from] * LENGTHS[to]


## Converts a mass [param value] between units [param from] and [param to].
static func convert_mass(value: float, from: Mass, to: Mass) -> float:
	return value / MASSES[from] * MASSES[to]


## Converts a power [param value] between units [param from] and [param to].
static func convert_power(value: float, from: Power, to: Power) -> float:
	return value / POWERS[from] * POWERS[to]


## Converts a speed [param value] between units [param from] and [param to].
static func convert_speed(value: float, from: Speed, to: Speed) -> float:
	return value / SPEEDS[from] * SPEEDS[to]


## Converts a duration [param value] between units [param from] and [param to].
static func convert_duration(value: float, from: Duration, to: Duration) -> float:
	return value / DURATIONS[from] * DURATIONS[to]
