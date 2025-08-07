class_name InSimLAPPacket
extends InSimPacket
## LAP time packet
##
## This packet is received when a player or AI completes a lap.

## Conversion factor between standard units and LFS-encoded values.
const TIME_MULTIPLIER := 1000.0
## Conversion factor between standard units and LFS-encoded values.
const FUEL_MULTIPLIER := 2.0

const PACKET_SIZE := 20  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_LAP  ## The packet's type, see [enum InSim.Packet].
var plid := 0  ## player's unique id

var lap_time := 0  ## lap time (ms)
var elapsed_time := 0  ## total time (ms)

var laps_done := 0  ## laps completed
var flags := 0  ## player flags

var penalty := InSim.Penalty.PENALTY_NONE  ## current penalty value (see [enum InSim.Penalty])
var num_stops := 0  ## number of pit stops
var fuel200 := 0  ## /showfuel yes: double fuel percent / no: 255

var gis_lap_time := 0.0  ## Lap time in seconds
var gis_elapsed_time := 0.0  ## Total race time in seconds
var gis_fuel := 0.0  ## Remaining fuel as a percentage, or [code]-1[/code] if fuel is hidden.


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	receivable = true


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [get_type_string(), size, packet_size])
		return
	super(packet)
	plid = read_byte()
	lap_time = read_unsigned()
	elapsed_time = read_unsigned()
	laps_done = read_word()
	flags = read_word()
	var _sp0 := read_byte()
	penalty = read_byte() as InSim.Penalty
	num_stops = read_byte()
	fuel200 = read_byte()


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": plid,
		"LTime": lap_time,
		"ETime": elapsed_time,
		"LapsDone": laps_done,
		"Flags": flags,
		"Penalty": penalty,
		"NumStops": num_stops,
		"Fuel200": fuel200,
	}


func _get_pretty_text() -> String:
	return "PLID %d completed a lap (%s, %d lap%s completed, %d pit stop%s)" % [
		plid,
		GISTime.get_time_string_from_seconds(lap_time / 1000.0),
		laps_done,
		"" if laps_done <= 1 else "s",
		num_stops,
		"" if num_stops <= 1 else "s",
	]


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(
		dict,
		["PLID", "LTime", "ETime", "LapsDone", "Flags", "Penalty", "NumStops", "Fuel200"],
	):
		return
	plid = dict["PLID"]
	lap_time = dict["LTime"]
	elapsed_time = dict["ETime"]
	laps_done = dict["LapsDone"]
	flags = dict["Flags"]
	penalty = dict["Penalty"]
	num_stops = dict["NumStops"]
	fuel200 = dict["Fuel200"]


func _update_gis_values() -> void:
	gis_lap_time = lap_time / TIME_MULTIPLIER
	gis_elapsed_time = elapsed_time / TIME_MULTIPLIER
	gis_fuel = fuel200 / FUEL_MULTIPLIER if fuel200 != 255 else -1.0
