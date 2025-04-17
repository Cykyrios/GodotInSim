class_name InSimSSHPacket
extends InSimPacket

## ScreenSHot packet

const SCREENSHOT_NAME_MAX_LENGTH := 32  # last byte must be zero, so actual value is decreased by one

const PACKET_SIZE := 40
const PACKET_TYPE := InSim.Packet.ISP_SSH
var error := InSim.Screenshot.SSH_OK  ## 0 = OK / other values are listed in [enum InSim.Screenshot]

var sp0 := 0
var sp1 := 0
var sp2 := 0
var sp3 := 0

var screenshot_name := ""  ## name of screenshot file - last byte must be zero


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	receivable = true
	sendable = true


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [get_type_string(), size, packet_size])
		return
	super(packet)
	error = read_byte() as InSim.Screenshot
	sp0 = read_byte()
	sp1 = read_byte()
	sp2 = read_byte()
	sp3 = read_byte()
	screenshot_name = read_string(SCREENSHOT_NAME_MAX_LENGTH)


func _fill_buffer() -> void:
	super()
	add_byte(error)
	add_byte(sp0)
	add_byte(sp1)
	add_byte(sp2)
	add_byte(sp3)
	var _buffer := add_string(SCREENSHOT_NAME_MAX_LENGTH, screenshot_name)
	data_offset -= 1
	add_byte(0)  # last byte in replay name must be zero


func _get_data_dictionary() -> Dictionary:
	return {
		"Error": error,
		"Sp0": sp3,
		"Sp1": sp3,
		"Sp2": sp3,
		"Sp3": sp3,
		"Name": screenshot_name,
	}


func _get_pretty_text() -> String:
	return "Screenshot: %s - %s" % [InSim.Screenshot.keys()[error], screenshot_name]


static func create(
	reqi: int, ssh_name: String, ssh_error := InSim.Screenshot.SSH_OK
) -> InSimSSHPacket:
	var packet := InSimSSHPacket.new()
	packet.req_i = reqi
	packet.error = ssh_error
	packet.screenshot_name = ssh_name
	return packet
