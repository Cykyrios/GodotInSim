class_name InSimRSTPacket
extends InSimPacket
## Race STart packet
##
## This packet is received when the session starts, or upon request via
## [constant InSim.Tiny.TINY_RST].

const TRACK_NAME_LENGTH := 6  ## Track name length

const PACKET_SIZE := 28  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_RST  ## The packet's type, see [enum InSim.Packet].

var zero := 0  ## Zero byte

var race_laps := 0  ## 0 if qualifying
var qual_mins := 0  ## 0 if race
var num_players := 0  ## Number of players in race
## Lap timing: bits 6 and 7 ([code]timing & 0xc0[/code]):[br]
## [code]0x40[/code]: standard lap timing is being used[br]
## [code]0x80[/code]: custom timing - user checkpoints have been placed[br]
## [code]0xc0[/code]: no lap timing - e.g. open config with no user checkpoints[br]
## bits 0 and 1 ([code]timing & 0x03[/code]): number of checkpoints if lap timing is enabled
var timing := 0

var track := ""  ## Short track name
var weather := 0  ## Weather (depends on track)
var wind := 0  ## Wind (none / low / high)

var flags := 0  ## Race flags (must pit, can reset, etc - see [enum InSim.HostFlag])
var num_nodes := 0  ## Total number of nodes in the path
var finish := 0  ## Node index - finish line
var split1 := 0  ## Node index - split 1
var split2 := 0  ## Node index - split 2
var split3 := 0  ## Node index - split 3


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
	zero = read_byte()
	race_laps = read_byte()
	qual_mins = read_byte()
	num_players = read_byte()
	timing = read_byte()
	track = read_string(TRACK_NAME_LENGTH)
	weather = read_byte()
	wind = read_byte()
	flags = read_word()
	num_nodes = read_word()
	finish = read_word()
	split1 = read_word()
	split2 = read_word()
	split3 = read_word()


func _get_data_dictionary() -> Dictionary:
	return {
		"RaceLaps": race_laps,
		"QualMins": qual_mins,
		"NumP": num_players,
		"Timing": timing,
		"Track": track,
		"Weather": weather,
		"Wind": wind,
		"Flags": flags,
		"NumNodes": num_nodes,
		"Finish": finish,
		"Split1": split1,
		"Split2": split2,
		"Split3": split3,
	}


func _get_pretty_text() -> String:
	var session_type := 0 if race_laps == 0 and qual_mins == 0 \
			else 1 if race_laps == 0 else 2
	var session := "Practice" if session_type == 0 else "Qualifying" if session_type == 1 \
			else "Race"
	var duration := "" if session_type == 0 else (" (%d minutes)" % [qual_mins]) if session_type == 1 \
			else (" (%d %s)" % [race_laps if race_laps < 100 \
			else (100 + 10 * (race_laps - 100)) if race_laps <= 190 else (race_laps - 190),
			"laps" if race_laps <= 190 else "hour%s" % ["" if race_laps == 191 else "s"]])
	var wind_strength := "no" if wind == 0 else "low" if wind == 1 else "high"
	return "%s started%s at %s (%s wind)" % [session, duration, track, wind_strength]


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(
		dict,
		[
			"RaceLaps", "QualMins", "NumP", "Timing", "Track", "Weather", "Wind",
			"Flags", "NumNodes", "Finish", "Split1", "Split2", "Split3",
		],
	):
		return
	race_laps = dict["RaceLaps"]
	qual_mins = dict["QualMins"]
	num_players = dict["NumP"]
	timing = dict["Timing"]
	track = dict["Track"]
	weather = dict["Weather"]
	wind = dict["Wind"]
	flags = dict["Flags"]
	num_nodes = dict["NumNodes"]
	finish = dict["Finish"]
	split1 = dict["Split1"]
	split2 = dict["Split2"]
	split3 = dict["Split3"]
