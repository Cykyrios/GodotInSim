class_name InSimCPRPacket
extends InSimPacket


const PACKET_SIZE := 36
const PACKET_TYPE := InSim.Packet.ISP_CPR
var ucid := 0

var player_name := ""
var plate := ""


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	ucid = read_byte()
	player_name = read_string(24)
	plate = read_string(8)


func _get_data_dictionary() -> Dictionary:
	return {
		"UCID": ucid,
		"PName": player_name,
		"Plate": plate,
	}
