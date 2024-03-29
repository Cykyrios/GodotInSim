class_name RelayARQPacket
extends InSimRelayPacket


const PACKET_SIZE := 4
const PACKET_TYPE := InSim.Packet.IRP_ARQ

var sp0 := 0


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
