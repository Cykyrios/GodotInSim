class_name InSimPLLPacket
extends InSimPacket

## PLayer Leave race packet (spectate - removed from player list)

const PACKET_SIZE := 4
const PACKET_TYPE := InSim.Packet.ISP_PLL
var player_id := 0  ## player's unique id


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	receivable = true


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	player_id = read_byte()


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": player_id,
	}
