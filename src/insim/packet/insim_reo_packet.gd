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
	num_players = mini(num_players, MAX_PLAYERS)
	add_byte(num_players)
	for i in num_players:
		add_byte(plids[i])
	for i in MAX_PLAYERS - num_players:
		add_byte(0)


func _get_data_dictionary() -> Dictionary:
	return {
		"NumP": num_players,
		"PLID": plids,
	}


func _get_pretty_text() -> String:
	var text := "%d player%s" % [num_players, "s" if num_players > 1 else ""]
	for i in plids.size():
		if plids[i] == 0:
			break
		text += "%s %s" % [":" if i == 0 else ",", "PLID %d" % [plids[i]]]
	return text


static func create(reo_num: int, reo_plids: Array[int]) -> InSimREOPacket:
	var packet := InSimREOPacket.new()
	packet.num_players = reo_num
	packet.plids = reo_plids.duplicate()
	return packet
