class_name InSimSCHPacket
extends InSimPacket

## Single CHaracter packet
##
## You can send individual key presses to LFS with this packet.
## For standard keys (e.g. V and H) you should send a capital letter.
## This does not work with some keys like F keys, arrows or CTRL keys.
## You can also use [InSimMSTPacket] with the /press /shift /ctrl /alt commands.

const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_SCH

var zero := 0

var char_byte := 0  ## key to press
var flags := 0  ## bit 0: SHIFT / bit 1: CTRL
var spare2 := 0
var spare3 := 0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	sendable = true


func _fill_buffer() -> void:
	super()
	add_byte(zero)
	add_byte(char_byte)
	add_byte(flags)
	add_byte(spare2)
	add_byte(spare3)


func _get_data_dictionary() -> Dictionary:
	return {
		"Zero": zero,
		"CharB": char_byte,
		"Flags": flags,
		"Spare2": spare2,
		"Spare3": spare3,
	}


func _get_pretty_text() -> String:
	return "Sent single character %s%s" % [PackedByteArray([char_byte]).get_string_from_ascii(),
			"" if flags == 0 else " (%s%s)" % ["+Shift" if flags & 0b01 else "",
			"+Ctrl" if flags & 0b10 else ""]]


static func create(sch_char: int, sch_flags: int) -> InSimSCHPacket:
	var packet := InSimSCHPacket.new()
	packet.char_byte = sch_char
	packet.flags = sch_flags
	return packet
