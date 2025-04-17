class_name InSimACRPacket
extends InSimPacket

## Admin Command Report packet

const PACKET_MIN_SIZE := 12
const PACKET_MAX_SIZE := 72
const PACKET_TYPE := InSim.Packet.ISP_ACR
const MSG_MAX_LENGTH := 64

var zero := 0

var ucid := 0  ## connection's unique id (0 = host)
var admin := 0  ## set if user is an admin
var result := 0  ## 1 - processed / 2 - rejected / 3 - unknown command
var sp3 := 0

var text := ""  ## 4, 8, 12... 64 characters - last byte is zero


func _init() -> void:
	size = PACKET_MAX_SIZE
	type = PACKET_TYPE
	receivable = true


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if (
		packet_size < PACKET_MIN_SIZE
		or packet_size > PACKET_MAX_SIZE
		or packet_size % SIZE_MULTIPLIER != 0
	):
		push_error("%s packet expected size [%d..%d step %d], got %d." % [get_type_string(),
				PACKET_MIN_SIZE, PACKET_MAX_SIZE, SIZE_MULTIPLIER, packet_size])
		return
	super(packet)
	zero = read_byte()
	ucid = read_byte()
	admin = read_byte()
	result = read_byte()
	sp3 = read_byte()
	text = read_string(packet_size - data_offset)


func _get_data_dictionary() -> Dictionary:
	return {
		"Zero": zero,
		"UCID": ucid,
		"Admin": admin,
		"Result": result,
		"Sp3": sp3,
		"Text": text,
	}


func _get_pretty_text() -> String:
	var result_string := "Processed" if result == 1 else "Rejected" if result == 2 else "Unknown"
	return "%s admin command from UCID %d (%sadmin): %s" % [result_string, ucid,
			"not " if admin == 0 else "", text]
