class_name InSimInitializationData
extends RefCounted


var udp_port := 0
var flags := 0

var prefix := "":
	set(text):
		prefix = text.left(InSimISIPacket.PREFIX_LENGTH)
var interval := 0:
	set(value):
		interval = value
		if interval < 0:
			interval = 0

var admin := ""
var i_name := "Godot InSim"


static func create(
	init_name: String, init_admin: String, init_flags: int, init_prefix: String,
	init_interval := 0, init_udp := 0
) -> InSimInitializationData:
	var init_data := InSimInitializationData.new()
	# i_name and admin are trimmed to ISI packet max lengths, but both are zero-terminated strings.
	init_data.i_name = init_name.left(InSimISIPacket.NAME_LENGTH)
	init_data.admin = init_admin.left(InSimISIPacket.ADMIN_LENGTH)
	init_data.flags = init_flags
	init_data.prefix = init_prefix
	init_data.interval = init_interval
	init_data.udp_port = init_udp
	return init_data
