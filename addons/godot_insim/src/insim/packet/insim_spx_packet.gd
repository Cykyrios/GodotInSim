class_name InSimSPXPacket
extends InSimPacket
## SPlit X time packet
##
## This packet is received when a player or AI crosses a sector split line.

## Conversion factor between standard units and LFS-encoded values.
const TIME_MULTIPLIER := 1000.0
## Conversion factor between standard units and LFS-encoded values.
const FUEL_MULTIPLIER := 2.0

const PACKET_SIZE := 16  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_SPX  ## The packet's type, see [enum InSim.Packet].

var plid := 0  ## Player's unique id

var split_time := 0  ## Split time (ms)
var elapsed_time := 0  ## Total time (ms)

var split := 0  ## Split number 1, 2, 3
var penalty := InSim.Penalty.PENALTY_NONE  ## Current penalty value (see [enum InSim.Penalty])
var num_stops := 0  ## Number of pit stops
var fuel200 := 0  ## /showfuel yes: double fuel percent / no: 255

var gis_split_time := 0.0  ## Split time in seconds
var gis_elapsed_time := 0.0  ## Total time in seconds
var gis_fuel := 0.0  ## Fuel as a percentage, or -1 if fuel is hidden.


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
	split_time = read_unsigned()
	elapsed_time = read_unsigned()
	split = read_byte()
	penalty = read_byte() as InSim.Penalty
	num_stops = read_byte()
	fuel200 = read_byte()


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": plid,
		"STime": split_time,
		"ETime": elapsed_time,
		"Split": split,
		"Penalty": penalty,
		"NumStops": num_stops,
		"Fuel200": fuel200,
	}


func _get_pretty_text() -> String:
	return "PLID %d crossed split %d (%s, %d pit stop%s)" % [
		plid,
		split,
		GISTime.get_time_string_from_seconds(split_time / 1000.0),
		num_stops,
		"" if num_stops <= 1 else "s",
	]


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(dict, ["PLID", "STime", "ETime", "Split"]):
		return
	plid = dict["PLID"]
	split_time = dict["STime"]
	elapsed_time = dict["ETime"]
	split = dict["Split"]
	penalty = dict["Penalty"]
	num_stops = dict["NumStops"]
	fuel200 = dict["Fuel200"]


func _update_gis_values() -> void:
	gis_split_time = split_time / TIME_MULTIPLIER
	gis_elapsed_time = elapsed_time / TIME_MULTIPLIER
	gis_fuel = fuel200 / FUEL_MULTIPLIER if fuel200 != 255 else -1.0
