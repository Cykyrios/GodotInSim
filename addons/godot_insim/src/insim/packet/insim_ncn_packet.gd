class_name InSimNCNPacket
extends InSimPacket


const PACKET_SIZE := 56
const PACKET_TYPE := InSim.Packet.ISP_NCN
var ucid := 0

var user_name := ""
var player_name := ""

var admin := 0
var total := 0
var flags := 0
var sp3 := 0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	ucid = read_byte(packet)
	user_name = read_string(packet, 24)
	player_name = read_string(packet, 24)
	admin = read_byte(packet)
	total = read_byte(packet)
	flags = read_byte(packet)
	sp3 = read_byte(packet)


func _get_data_dictionary() -> Dictionary:
	return {
		"UCID": ucid,
		"UName": user_name,
		"PName": player_name,
		"Admin": admin,
		"Total": total,
		"Flags": flags,
		"Sp3": sp3,
	}
