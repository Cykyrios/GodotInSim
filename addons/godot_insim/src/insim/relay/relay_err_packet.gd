class_name RelayERRPacket
extends InSimRelayPacket
## Relay error packet
##
## This packet is received when an error occurs after sending an [InSimRelayPacket].

const PACKET_SIZE := 4 ## Packet size
const PACKET_TYPE := InSim.Packet.IRP_ERR  ## The packet's type, see [enum InSim.Packet].

var error := InSim.RelayError.IR_ERR_PACKET  ## Relay error, see [enum InSim.RelayError].


func _init() -> void:
	super()
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
