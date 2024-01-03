class_name InSimISIPacket
extends InSimPacket


const PACKET_SIZE := 44
const PACKET_TYPE := InSim.Packet.ISP_ISI
const REQ_I := 1
var zero := 0

var udp_port := 0
var flags := 0

var insim_version := InSim.VERSION
var prefix := ""
var interval := 0

var admin := ""
var i_name := "Godot InSim"


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	req_i = REQ_I


func _fill_buffer() -> void:
	super()
	add_byte(zero)
	add_word(udp_port)
	add_word(flags)

	add_byte(insim_version)
	add_string(1, prefix)
	add_word(interval)

	add_string(16, admin)
	add_string(16, i_name)


func _get_data_dictionary() -> Dictionary:
	return {
		"Zero": zero,
		"UDPPort": udp_port,
		"Flags": flags,
		"InSimVer": insim_version,
		"Prefix": prefix,
		"Interval": interval,
		"Admin": admin,
		"IName": i_name,
	}
