class_name RelayARQPacket
extends InSimRelayPacket
## Relay admin request
##
## This packet is sent to request the admin status of the currently connected host.

const PACKET_SIZE := 4  ## Packet size
const PACKET_TYPE := InSim.Packet.IRP_ARQ  ## The packet's type, see [enum InSim.Packet].

var sp0 := 0  ## Spare


## Creates and returns a new [RelayARQPacket] with the given [param reqi].
static func create(reqi: int) -> RelayARQPacket:
	var packet := RelayARQPacket.new()
	packet.req_i = reqi
	return packet


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	sendable = true


func _fill_buffer() -> void:
	super()
	add_byte(sp0)


func _get_data_dictionary() -> Dictionary:
	return {
		"Sp0": sp0,
	}
