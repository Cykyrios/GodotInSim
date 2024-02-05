class_name InSimPLAPacket
extends InSimPacket


const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_PLA
var player_id := 0

var fact := 0
var sp1 := 0
var sp2 := 0
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
	player_id = read_byte()
	fact = read_byte()
	sp1 = read_byte()
	sp2 = read_byte()
	sp3 = read_byte()


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": player_id,
		"Fact": fact,
		"Sp1": sp1,
		"Sp2": sp2,
		"Sp3": sp3,
	}
