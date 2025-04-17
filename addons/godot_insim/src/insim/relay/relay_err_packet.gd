class_name RelayERRPacket
extends InSimRelayPacket


const PACKET_SIZE := 4
const PACKET_TYPE := InSim.Packet.IRP_ERR

var error := InSim.RelayError.IR_ERR_PACKET


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
	error = read_byte() as InSim.RelayError


func _get_data_dictionary() -> Dictionary:
	return {
		"ErrNo": error,
	}
