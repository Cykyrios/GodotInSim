class_name InSimSFPPacket
extends InSimPacket
## State Flags Pack
##
## This packet is sent to update some [enum InSim.State] flags.[br]
## [b]Note:[/b] Only the following states can be set with this packet:
## [constant InSim.State.ISS_SHIFTU_NO_OPT], [constant InSim.State.ISS_SHOW_2D],
## [constant InSim.State.ISS_MPSPEEDUP], [constant InSim.State.ISS_SOUND_MUTE]; other states
## must be set by using keypresses or messages.

const PACKET_SIZE := 8  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_SFP  ## The packet's type, see [enum InSim.Packet].

var flag := InSim.State.ISS_SHIFTU_NO_OPT  ## The state flag to set
var off_on := 0  ## 0 = off / 1 = on


## Creates and returns a new [InSimSFPPacket] from the given parameters.
static func create(sfp_flag: InSim.State, sfp_on: bool) -> InSimSFPPacket:
	var packet := InSimSFPPacket.new()
	packet.flag = sfp_flag
	packet.off_on = 1 if sfp_on else 0
	return packet


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	sendable = true


func _fill_buffer() -> void:
	super()
	add_byte(0)  # zero
	add_word(flag)
	add_byte(off_on)
	add_byte(0)  # sp3


func _get_data_dictionary() -> Dictionary:
	return {
		"Flag": flag,
		"OffOn": off_on,
	}


func _get_pretty_text() -> String:
	return "Set flag %s to %s" % [
		str(InSim.State.keys()[InSim.State.values().find(flag)]) if (
			flag in InSim.State.values()
		) else "INVALID FLAG",
		"OFF" if off_on == 0 else "ON",
	]


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(dict, ["Flag", "OffOn"]):
		return
	flag = dict["Flag"]
	off_on = dict["OffOn"]
