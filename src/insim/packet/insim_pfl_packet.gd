class_name InSimPFLPacket
extends InSimPacket

## Player FLags packet (help flags changed)

const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_PFL
var plid := 0  ## player's unique id

var flags := 0  ## player flags (see [enum InSim.PlayerFlag])
var spare := 0


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
	flags = read_word()
	spare = read_word()


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": plid,
		"Flags": flags,
		"Spare": spare,
	}


func _get_pretty_text() -> String:
	return "PLID %d changed flags: %s" % [plid, flags]
