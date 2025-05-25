class_name InSimCRSPacket
extends InSimPacket
## Car ReSet packet
##
## This packet is received when a player resets their vehicle.

const PACKET_SIZE := 4  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_CRS  ## The packet's type, see [enum InSim.Packet].
var plid := 0  ## player's unique id


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	receivable = true


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [get_type_string(), size, packet_size])
		return
	super(packet)
	plid = read_byte()


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": plid,
	}


func _get_pretty_text() -> String:
	return "PLID %d: vehicle reset" % [plid]
