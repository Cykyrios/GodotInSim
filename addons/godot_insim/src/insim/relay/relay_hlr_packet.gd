class_name RelayHLRPacket
extends InSimRelayPacket


const PACKET_SIZE := 4
const PACKET_TYPE := InSim.Packet.IRP_HLR
var sp0 := 0


static func create(reqi: int) -> RelayHLRPacket:
	var packet := RelayHLRPacket.new()
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
