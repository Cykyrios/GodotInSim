class_name RelayARPPacket
extends InSimRelayPacket
## Relay admin reply
##
## This packet is received as a reply to an admin request from a [RelayARQPacket].

const PACKET_SIZE := 4  ## Packet size
const PACKET_TYPE := InSim.Packet.IRP_ARP  ## The packet's type, see [enum InSim.Packet].

var admin := 0  ## Admin status


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
	admin = read_byte()


func _get_data_dictionary() -> Dictionary:
	return {
		"Admin": admin,
	}
