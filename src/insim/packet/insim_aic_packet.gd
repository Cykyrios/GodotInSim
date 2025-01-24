class_name InSimAICPacket
extends InSimPacket

## AI Control packet

const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_AIC
var zero := 0

var plid := 0  ## Unique ID of AI player to control
## Select input value to set
## Special values for Input:
## 254 - reset all
## 255 - stop control
var input := InSim.AIControl.CS_NUM
var value := 0  ## Value to set


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	sendable = true


func _fill_buffer() -> void:
	super()
	add_byte(zero)
	add_byte(plid)
	add_byte(input)
	add_word(value)


func _get_data_dictionary() -> Dictionary:
	return {
		"Zero": zero,
		"PLID": plid,
		"Input": input,
		"Value": value,
	}
