class_name InSimRSTPacket
extends InSimPacket

## Race STart packet

const TRACK_NAME_LENGTH := 6

const PACKET_SIZE := 28
const PACKET_TYPE := InSim.Packet.ISP_RST
var zero := 0

var race_laps := 0  ## 0 if qualifying
var qual_mins := 0  ## 0 if race
var num_players := 0  ## number of players in race
## lap timing: bits 6 and 7 ([code]timing & 0xc0[/code]):[br]
## [code]0x40[/code]: standard lap timing is being used[br]
## [code]0x80[/code]: custom timing - user checkpoints have been placed[br]
## [code]0xc0[/code]: no lap timing - e.g. open config with no user checkpoints[br]
## bits 0 and 1 ([code]timing & 0x03[/code]): number of checkpoints if lap timing is enabled
var timing := 0

var track := ""  ## short track name
var weather := 0  ## weather (depends on track)
var wind := 0  ## wind (none / low / high)

var flags := 0  ## race flags (must pit, can reset, etc - see [enum InSim.HostFlag])
var num_nodes := 0  ## total number of nodes in the path
var finish := 0  ## node index - finish line
var split1 := 0  ## node index - split 1
var split2 := 0  ## node index - split 2
var split3 := 0  ## node index - split 3


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
		"Zero": zero,
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
