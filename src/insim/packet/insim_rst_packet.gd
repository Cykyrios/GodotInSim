class_name InSimRSTPacket
extends InSimPacket


const TRACK_NAME_LENGTH := 6

const PACKET_SIZE := 28
const PACKET_TYPE := InSim.Packet.ISP_RST
var zero := 0

var race_laps := 0
var qual_mins := 0
var num_players := 0
var timing := 0

var track := ""
var weather := 0
var wind := 0

var flags := 0
var num_nodes := 0
var finish := 0
var split1 := 0
var split2 := 0
var split3 := 0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


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
