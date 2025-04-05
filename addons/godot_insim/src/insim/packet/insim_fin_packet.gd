class_name InSimFINPacket
extends InSimPacket

## FINished packet - Finished race notification (not a final result - use [InSimRESPacket])

const TIME_MULTIPLIER := 1000.0

const PACKET_SIZE := 20
const PACKET_TYPE := InSim.Packet.ISP_FIN
var plid := 0  ## player's unique id (0 = player left before result was sent)

var race_time := 0  ## race time (ms)
var best_lap := 0  ## best lap (ms)

var sp_a := 0
var num_stops := 0  ## number of pit stops
var confirm := 0  ## confirmation flags: disqualified etc - see [enum InSim.Confirmation]
var sp_b := 0

var laps_done := 0  ## laps completed
var flags := 0  ## player flags: help settings etc - see [enum InSim.PlayerFlag]

var gis_race_time := 0.0
var gis_best_lap := 0.0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	receivable = true


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	plid = read_byte()
	race_time = read_unsigned()
	best_lap = read_unsigned()
	sp_a = read_byte()
	num_stops = read_byte()
	confirm = read_byte()
	sp_b = read_byte()
	laps_done = read_word()
	flags = read_word()


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": plid,
		"TTime": race_time,
		"BTime": best_lap,
		"SpA": sp_a,
		"NumStops": num_stops,
		"Confirm": confirm,
		"SpB": sp_b,
		"LapsDone": laps_done,
		"Flags": flags,
	}


func _get_pretty_text() -> String:
	return "PLID %d finished (best lap: %s)" % [plid,
			GISTime.get_time_string_from_seconds(gis_best_lap)]


func _update_gis_values() -> void:
	gis_race_time = race_time / TIME_MULTIPLIER
	gis_best_lap = best_lap / TIME_MULTIPLIER
