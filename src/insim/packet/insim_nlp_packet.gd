class_name InSimNLPPacket
extends InSimPacket

## Node and Lap Packet - variable size

const MAX_CARS := 40
const PACKET_MIN_SIZE := 4 + NodeLap.STRUCT_SIZE + 2
const PACKET_MAX_SIZE := 4 + MAX_CARS * NodeLap.STRUCT_SIZE
const PACKET_TYPE := InSim.Packet.ISP_NLP

var num_players := 0  ## number of players in race
var info: Array[NodeLap] = []  ## node and lap of each player, 1 to [constant MAX_CARS]


func _init() -> void:
	size = PACKET_MAX_SIZE
	type = PACKET_TYPE
	receivable = true


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if (
		packet_size < PACKET_MIN_SIZE
		or packet_size > PACKET_MAX_SIZE
		or packet_size % SIZE_MULTIPLIER != 0
	):
		push_error("%s packet expected size [%d..%d step %d], got %d." % [InSim.Packet.keys()[type],
				PACKET_MIN_SIZE, PACKET_MAX_SIZE, SIZE_MULTIPLIER, packet_size])
		return
	super(packet)
	num_players = read_byte()
	info.clear()
	var struct_size := NodeLap.STRUCT_SIZE
	for i in num_players:
		var player_info := NodeLap.new()
		player_info.set_from_buffer(packet.slice(data_offset, data_offset + struct_size))
		data_offset += struct_size
		info.append(player_info)


func _get_data_dictionary() -> Dictionary:
	return {
		"NumP": num_players,
		"Info": info,
	}
