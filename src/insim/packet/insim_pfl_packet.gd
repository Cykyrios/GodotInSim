class_name InSimPFLPacket
extends InSimPacket


const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_PFL
var player_id := 0

var flags := 0
var spare := 0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	player_id = read_byte()
	flags = read_word()
	spare = read_word()


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": player_id,
		"Flags": flags,
		"Spare": spare,
	}
