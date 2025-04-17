class_name RelayARPPacket
extends InSimRelayPacket


const PACKET_SIZE := 4
const PACKET_TYPE := InSim.Packet.IRP_ARP

var admin := 0


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
	admin = read_byte()


func _get_data_dictionary() -> Dictionary:
	return {
		"Admin": admin,
	}
