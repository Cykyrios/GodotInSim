class_name InSimREOPacket
extends InSimPacket

## REOrder packet - this packet can be sent in either direction

const MAX_PLAYERS := 40

const PACKET_SIZE := 44
const PACKET_TYPE := InSim.Packet.ISP_REO
var num_players := 0  # number of players in race

var plids: Array[int] = []  ## all player ids in new order


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	var _discard := plids.resize(MAX_PLAYERS)
	for i in MAX_PLAYERS:
		plids[i] = 0
	receivable = true
	sendable = true


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	num_players = read_byte()
	plids.clear()
	for i in MAX_PLAYERS:
		plids.append(read_byte())


func _fill_buffer() -> void:
	super()
	add_byte(num_players)
	for i in MAX_PLAYERS:
		add_byte(plids[i])


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": num_players,
		"NumP": plids,
	}
