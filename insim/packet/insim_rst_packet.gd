class_name InSimRSTPacket
extends InSimPacket


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


func _get_data_dictionary() -> Dictionary:
	var data := {
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
	return data


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	zero = read_byte(packet)
	race_laps = read_byte(packet)
	qual_mins = read_byte(packet)
	num_players = read_byte(packet)
	timing = read_byte(packet)
	track = read_string(packet, 6)
	weather = read_byte(packet)
	wind = read_byte(packet)
	flags = read_word(packet)
	num_nodes = read_word(packet)
	finish = read_word(packet)
	split1 = read_word(packet)
	split2 = read_word(packet)
	split3 = read_word(packet)
