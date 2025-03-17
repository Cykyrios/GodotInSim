class_name InSimPLPPacket
extends InSimPacket

## PLayer Pits packet (go to settings - stays in player list)

const PACKET_SIZE := 4
const PACKET_TYPE := InSim.Packet.ISP_PLP
var plid := 0  ## player's unique id


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
	plid = read_byte()


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": plid,
	}


func _get_pretty_text() -> String:
	return "PLID %d pitted" % [plid]
