class_name InSimCPRPacket
extends InSimPacket

## Conn Player Rename packet

const PLAYER_NAME_MAX_LENGTH := 24
const PLATE_MAX_LENGTH := 8

const PACKET_SIZE := 36
const PACKET_TYPE := InSim.Packet.ISP_CPR
var ucid := 0  ## unique id of the connection

var player_name := ""  ## new name
var plate := ""  ## number plate - NO ZERO AT END!


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	receivable = true


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [get_type_string(), size, packet_size])
		return
	super(packet)
	ucid = read_byte()
	player_name = read_string(PLAYER_NAME_MAX_LENGTH)
	plate = read_string(PLATE_MAX_LENGTH, false)


func _get_data_dictionary() -> Dictionary:
	return {
		"UCID": ucid,
		"PName": player_name,
		"Plate": plate,
	}


func _get_pretty_text() -> String:
	return "UCID %d renamed to %s" % [ucid, player_name]
