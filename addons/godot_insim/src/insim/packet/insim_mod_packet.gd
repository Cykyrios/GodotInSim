class_name InSimMODPacket
extends InSimPacket

## MODe packet - send to LFS to change screen mode

const PACKET_SIZE := 20
const PACKET_TYPE := InSim.Packet.ISP_MOD
var zero := 0

var bits16 := 0  ## set to choose 16-bit
var refresh_rate := 0  ## refresh rate - zero for default
var width := 0  ## 0 means go to window
var height := 0  ## 0 means go to window


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	sendable = true


func _fill_buffer() -> void:
	super()
	add_byte(zero)
	add_int(bits16)
	add_int(refresh_rate)
	add_int(width)
	add_int(height)


func _get_data_dictionary() -> Dictionary:
	return {
		"Zero": zero,
		"Bits16": bits16,
		"RR": refresh_rate,
		"Width": width,
		"Height": height,
	}


func _get_pretty_text() -> String:
	return "%dx%d@%dHz%s" % [width, height, refresh_rate, " (16bit)" if bits16 == 1 else ""]


static func create(
	mod_width: int, mod_height: int, mod_refresh := 0, mod_bits16 := 0
) -> InSimMODPacket:
	var packet := InSimMODPacket.new()
	packet.bits16 = mod_bits16
	packet.refresh_rate = mod_refresh
	packet.width = mod_width
	packet.height = mod_height
	return packet
