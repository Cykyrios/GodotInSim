class_name InSimISIPacket
extends InSimPacket


var udp_port := 0
var flags := 0

var insim_version := InSim.VERSION
var prefix := ""
var interval := 0

var admin := ""
var i_name := ""


func _init() -> void:
	size = 44
	type = InSim.Packet.ISP_ISI
	req_i = 1
	super()


func _fill_buffer() -> void:
	data_offset = HEADER_SIZE
	add_word(udp_port)
	add_word(flags)

	add_byte(insim_version)
	add_string(1, prefix)
	add_word(interval)

	add_string(16, admin)
	add_string(16, i_name)
