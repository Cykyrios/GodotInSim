class_name RelaySELPacket
extends InSimRelayPacket


const PACKET_SIZE := 68
const PACKET_TYPE := InSim.Packet.IRP_SEL
const HOST_NAME_LENGTH := 32
const ADMIN_LENGTH := 16
const SPEC_LENGTH := 16

var zero := 0

var host_name := ""
var admin := ""
var spec := ""


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	sendable = true


func _fill_buffer() -> void:
	super()
	add_byte(zero)
	add_string(HOST_NAME_LENGTH, host_name)
	add_string(ADMIN_LENGTH, admin)
	add_string(SPEC_LENGTH, spec)


func _get_data_dictionary() -> Dictionary:
	return {
		"Zero": zero,
		"HName": host_name,
		"Admin": admin,
		"Spec": spec,
	}
