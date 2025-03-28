class_name GISUtils
extends RefCounted


enum AccelerationUnit {METER_PER_SECOND_SQUARED, G}
enum AngleUnit {RADIAN, DEGREE}
enum ForceUnit {NEWTON}
enum LengthUnit {METER, KILOMETER, CENTIMETER, MILLIMETER, MILE, INCH}
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


## Returns a time value in seconds from a time string in format "hh:mm:ss.dd". Validation is not
## performed, strings such as "62:70.5" are considered valid and will return 3790.5 seconds. Hours
## and minutes can be omitted is they are leading zeros.
static func get_seconds_from_time_string(time: String) -> float:
	var regex := RegEx.create_from_string(r"(?:(\d+):)?(?:(\d+):)?(\d+)(.\d*)?")
	var regex_match := regex.search(time)
	if not regex_match:
		return 0
	var hours := regex_match.strings[1].to_float()
	var minutes := regex_match.strings[2].to_float()
	var seconds := regex_match.strings[3].to_float() + regex_match.strings[4].to_float()
	if hours > 0 and is_zero_approx(minutes) and regex_match.strings[2].is_empty():
		minutes = hours
		hours = 0
	var result := 3600 * hours + 60 * minutes + seconds
	return result


## Returns a time string from provided [param time] in seconds as "hh:mm:ss.ddd". Hours and minutes
## are omitted if they are leading zeros. The intended valid range is 0 to 360,000 seconds
## (100 hours) excluded, values outside this range return 0.
static func get_time_string_from_seconds(
	time: float, decimal_places := 2, simplify_zero := false, show_plus_sign := false,
	always_show_minutes := false
) -> String:
	var negative := true if time < 0 else false
	if negative:
		time = -time
	if time >= 360_000:
		return get_time_string_from_seconds(0, decimal_places, show_plus_sign, simplify_zero,
				always_show_minutes)
	var hours := floori(time / 3600)
	var minutes := floori((time - 3600 * hours) / 60)
	var seconds := time - 3600 * hours - 60 * minutes
	var seconds_int := floori(seconds)
	var seconds_decimals := roundi((seconds - seconds_int) * pow(10, decimal_places))
	if len(str(seconds_decimals)) > decimal_places:
		seconds_int += 1
		seconds_decimals = 0
	return "%s%s%s%s" % ["+" if show_plus_sign and not negative else "-" if negative else "",
			"" if hours == 0 else "%d:" % [hours],
			"" if minutes == 0 and hours == 0 and not always_show_minutes \
					else "%d:" % [minutes] if simplify_zero and \
					(hours == 0 or always_show_minutes) \
					else "%02d:" % [minutes],
			("%d" % [seconds_int] if simplify_zero and minutes == 0 and hours == 0 \
					and not always_show_minutes \
					else "%02d" % [seconds_int]) \
					+ ".%0*d" % [decimal_places, seconds_decimals]]
