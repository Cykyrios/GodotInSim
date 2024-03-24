class_name InSimSFPPacket
extends InSimPacket

## State Flags Pack
##
## These states can be set with this packet:[br]
## [constant InSim.ISS_SHIFTU_NO_OPT] - SHIFT+U buttons hidden[br]
## [constant InSim.ISS_SHOW_2D] - showing 2d display[br]
## [constant InSim.ISS_MPSPEEDUP] - multiplayer speedup option[br]
## [constant InSim.ISS_SOUND_MUTE] - sound is switched off[br]
## Other states must be set by using keypresses or messages.

const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_SFP
var zero := 0

var flag := 0  ## the state to set
var off_on := 0  ## 0 = off / 1 = on
var sp3 := 0


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
