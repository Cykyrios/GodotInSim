class_name InSimSSHPacket
extends InSimPacket
## ScreenSHot packet
##
## This packet is sent to take a screenshot, and received as a reply.

## Screenshot name maximum length
const SCREENSHOT_NAME_MAX_LENGTH := 32  # last byte must be zero, actual value is decreased by one

const PACKET_SIZE := 40  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_SSH  ## The packet's type, see [enum InSim.Packet].
var error := InSim.Screenshot.SSH_OK  ## 0 = OK / other values are listed in [enum InSim.Screenshot]

var sp0 := 0  ## Spare
var sp1 := 0  ## Spare
var sp2 := 0  ## Spare
var sp3 := 0  ## Spare

var screenshot_name := ""  ## Name of screenshot file - last byte must be zero


## Creates and returns a new [InSimSSHPacket] from the given parameters.
static func create(
	reqi: int, ssh_name: String, ssh_error := InSim.Screenshot.SSH_OK
) -> InSimSSHPacket:
	var packet := InSimSSHPacket.new()
	packet.req_i = reqi
	packet.error = ssh_error
	packet.screenshot_name = ssh_name
	return packet


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
	add_byte(0, data_offset - 1)  # last byte in replay name must be zero


func _get_data_dictionary() -> Dictionary:
	return {
		"Error": error,
		"Name": screenshot_name,
	}


func _get_pretty_text() -> String:
	return "Screenshot: %s - %s" % [
		str(InSim.Screenshot.keys()[error]) if (
			error in InSim.Screenshot.values()
		) else "INVALID ERROR",
		screenshot_name,
	]


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(dict, ["Error", "Name"]):
		return
	error = dict["Error"]
	screenshot_name = dict["Name"]
