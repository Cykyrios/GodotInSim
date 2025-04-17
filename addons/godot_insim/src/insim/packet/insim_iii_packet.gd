class_name InSimIIIPacket
extends InSimPacket

## InsIm Info packet - /i message from user to host's InSim - variable size

const PACKET_MIN_SIZE := 12
const PACKET_MAX_SIZE := 72
const PACKET_TYPE := InSim.Packet.ISP_III
const MSG_MAX_LENGTH := 64

var zero := 0

var ucid := 0  ## connection's unique id (0 = host)
var plid := 0  ## player's unique id (if zero, use [member ucid])
var sp2 := 0
var sp3 := 0

var msg := ""  ## 4, 8, 12... 64 characters - last byte is zero


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
	plid = read_byte()
	sp2 = read_byte()
	sp3 = read_byte()
	msg = read_string(packet_size - data_offset)


func _get_data_dictionary() -> Dictionary:
	return {
		"Zero": zero,
		"UCID": ucid,
		"PLID": plid,
		"Sp2": sp2,
		"Sp3": sp3,
		"Msg": msg,
	}


func _get_pretty_text() -> String:
	return "/i message from %s: %s" % [
		("PLID %d" % [plid]) if plid != 0 else ("UCID %d" % [ucid]),
		msg,
	]
