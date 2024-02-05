class_name InSimREOPacket
extends InSimPacket


const MAX_PLAYERS := 40

const PACKET_SIZE := 44
const PACKET_TYPE := InSim.Packet.ISP_REO
var num_players := 0

var player_ids: Array[int] = []


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	var _discard := player_ids.resize(size)
	for i in size:
		player_ids[i] = 0


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	num_players = read_byte()
	player_ids.clear()
	for i in MAX_PLAYERS:
		player_ids.append(read_byte())


func _fill_buffer() -> void:
	super()
	add_byte(num_players)
	for i in MAX_PLAYERS:
		add_byte(player_ids[i])


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": num_players,
		"NumP": player_ids,
	}
