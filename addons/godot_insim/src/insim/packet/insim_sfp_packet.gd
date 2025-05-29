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

var zero := 0  ## Zero byte

var flag := InSim.State.ISS_SHIFTU_NO_OPT  ## The state flag to set
var off_on := 0  ## 0 = off / 1 = on
var sp3 := 0  ## Spare


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
	add_byte(zero)
	add_word(flag)
	add_byte(off_on)
	add_byte(sp3)


func _get_data_dictionary() -> Dictionary:
	return {
		"Zero": zero,
		"Flag": flag,
		"OffOn": off_on,
		"Sp3": sp3,
	}


func _get_pretty_text() -> String:
	return "Set flag %s to %s" % [InSim.State.keys()[flag], "OFF" if off_on == 0 else "ON"]
