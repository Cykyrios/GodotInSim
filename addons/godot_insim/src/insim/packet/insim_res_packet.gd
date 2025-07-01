class_name InSimRESPacket
extends InSimPacket
## RESult packet (qualify or confirmed finish)
##
## This packet is received when a player's result is confirmed.

## Conversion factor between standard units and LFS-encoded values.
const TIME_MULTIPLIER := 1000.0

const USERNAME_MAX_LENGTH := 24  ## Maximum username length
const PLAYER_NAME_MAX_LENGTH := 24  ## Maximum player name length
const PLATE_MAX_LENGTH := 8  ## Maximum plate length

const PACKET_SIZE := 84  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_RES  ## The packet's type, see [enum InSim.Packet].
var plid := 0  ## Player's unique id (0 = player left before result was sent)

var username := ""  ## Username
var player_name := ""  ## Nickame
var plate := ""  ## Number plate - NO ZERO AT END!
var car_name := ""  ## Skin prefix

var total_time := 0  ## (ms) Race or autocross: total time / qualify: session time
var best_lap := 0  ## (ms) Best lap

var sp_a := 0  ## Spare
var num_stops := 0  ## Number of pit stops
var confirm := 0  ## Confirmation flags: disqualified etc - see [enum InSim.Confirmation]
var sp_b := 0  ## Spare

var laps_done := 0  ## Number of laps completed
var flags := 0  ## Player flags: help settings etc - see [enum InSim.PlayerFlag]

var result_num := 0  ## Finish or qualify pos (0 = win / 255 = not added to table)
var num_results := 0  ## Total number of results (qualify doesn't always add a new one)
var penalty_seconds := 0  ## Penalty time in seconds (already included in race time)

var gis_total_time := 0.0  ## Total time in seconds
var gis_best_lap := 0.0  ## Best lap time in seconds


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
	username = read_string(USERNAME_MAX_LENGTH)
	player_name = read_string(PLAYER_NAME_MAX_LENGTH)
	plate = read_string(PLATE_MAX_LENGTH, false)
	car_name = read_car_name()
	total_time = read_unsigned()
	best_lap = read_unsigned()
	sp_a = read_byte()
	num_stops = read_byte()
	confirm = read_byte()
	sp_b = read_byte()
	laps_done = read_word()
	flags = read_word()
	result_num = read_byte()
	num_results = read_byte()
	penalty_seconds = read_word()


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": plid,
		"UName": username,
		"PName": player_name,
		"Plate": plate,
		"CName": car_name,
		"TTime": total_time,
		"BTime": best_lap,
		"NumStops": num_stops,
		"Confirm": confirm,
		"LapsDone": laps_done,
		"Flags": flags,
		"ResultNum": result_num,
		"NumRes": num_results,
		"PSeconds": penalty_seconds,
	}


func _get_pretty_text() -> String:
	return "PLID %d %s" % [plid, ("finished P%d" % [result_num + 1]) if result_num != 255 \
			else "did not finish"]


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(
		dict,
		[
			"PLID", "UName", "PName", "Plate", "CName", "TTime", "BTime", "NumStops",
			"Confirm", "LapsDone", "Flags", "ResultNum", "NumRes", "PSeconds",
		],
	):
		return
	plid = dict["PLID"]
	username = dict["UName"]
	player_name = dict["PName"]
	plate = dict["Plate"]
	car_name = dict["CName"]
	total_time = dict["TTime"]
	best_lap = dict["BTime"]
	num_stops = dict["NumStops"]
	confirm = dict["Confirm"]
	laps_done = dict["LapsDone"]
	flags = dict["Flags"]
	result_num = dict["ResultNum"]
	num_results = dict["NumRes"]
	penalty_seconds = dict["PSeconds"]


func _update_gis_values() -> void:
	gis_total_time = total_time / TIME_MULTIPLIER
	gis_best_lap = best_lap / TIME_MULTIPLIER
