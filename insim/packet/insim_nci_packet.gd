class_name InSimNCIPacket
extends InSimPacket


const PACKET_SIZE := 16
const PACKET_TYPE := InSim.Packet.ISP_NCI
var ucid := 0

var language := 0
var license := 0
var sp2 := 0
var sp3 := 0

var user_id := 0
var ip_address := 0


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
	language = read_byte(packet)
	license = read_byte(packet)
	sp2 = read_byte(packet)
	sp3 = read_byte(packet)
	user_id = read_unsigned(packet)
	ip_address = read_unsigned(packet)


func _get_data_dictionary() -> Dictionary:
	return {
		"UCID": ucid,
		"Language": language,
		"License": license,
		"Sp2": sp2,
		"Sp3": sp3,
		"UserID": user_id,
		"IPAddress": ip_address,
	}
