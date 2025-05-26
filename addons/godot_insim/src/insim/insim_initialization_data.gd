class_name InSimInitializationData
extends RefCounted
## Initialization data for InSim
##
## This class holds standard [InSim] initialization data to be sent through an [InSimISIPacket].

var udp_port := 0  ## UDP port for responses.
var flags := 0  ## Insim flags from [enum InSim.InitFlag].

## Single-character prefix used for prefix messages (see
## [constant InSim.MessageUserValue.MSO_PREFIX]).
var prefix := "":
	set(text):
		prefix = text.left(InSimISIPacket.PREFIX_LENGTH)
## Interval in milliseconds between NLP/MCI packet updates, disabled if [code]0[/code].
var interval := 0:
	set(value):
		interval = value
		if interval < 0:
			interval = 0

var admin := ""  ## Admin password
var i_name := "Godot InSim"  ## 15-character name of the InSim app


## Creates and returns a new [InSimInitializationData] object from the given parameters.
static func create(
	init_name: String, init_flags := 0, init_prefix := "", init_admin := "",
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
