class_name RelayHLRPacket
extends InSimRelayPacket
## Relay host list request
##
## This packet is sent to request the list of current hosts connected to the relay.

const PACKET_SIZE := 4  ## Packet size
const PACKET_TYPE := InSim.Packet.IRP_HLR  ## The packet's type, see [enum InSim.Packet].


## Creates and returns a new [RelayHLRPacket] with the given [param reqi].
static func create(reqi: int) -> RelayHLRPacket:
	var packet := RelayHLRPacket.new()
	packet.req_i = reqi
	return packet


func _init() -> void:
	super()
	size = PACKET_SIZE
	type = PACKET_TYPE
	sendable = true


func _fill_buffer() -> void:
	super()
	add_byte(0)  # sp0


func _get_data_dictionary() -> Dictionary:
	return {}
