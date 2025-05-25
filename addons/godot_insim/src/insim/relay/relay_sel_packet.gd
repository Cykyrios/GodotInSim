class_name RelaySELPacket
extends InSimRelayPacket
## Relay host selection packet
##
## This packet is sent to connect to the specified host.

const PACKET_SIZE := 68  ## Packet size
const PACKET_TYPE := InSim.Packet.IRP_SEL  ## The packet's type, see [enum InSim.Packet].
const HOST_NAME_LENGTH := 32  ## Maximum host name length
const ADMIN_LENGTH := 16  ## Maximum admin password length
const SPEC_LENGTH := 16  ## Maximum spectator password length

var zero := 0  ## Zero byte

var host_name := ""  ## Host name
var admin := ""  ## Admin password
var spec := ""  ## Spectator password


## Creates and returns a new [RelaySELPacket] from the given parameters.
static func create(reqi: int, sel_host: String, sel_admin := "", sel_spec := "") -> RelaySELPacket:
	var packet := RelaySELPacket.new()
	packet.req_i = reqi
	packet.host_name = sel_host
	packet.admin = sel_admin
	packet.spec = sel_spec
	return packet


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	sendable = true


func _fill_buffer() -> void:
	super()
	add_byte(zero)
	var _buffer := add_string(HOST_NAME_LENGTH, host_name)
	_buffer = add_string(ADMIN_LENGTH, admin)
	_buffer = add_string(SPEC_LENGTH, spec)


func _get_data_dictionary() -> Dictionary:
	return {
		"Zero": zero,
		"HName": host_name,
		"Admin": admin,
		"Spec": spec,
	}
