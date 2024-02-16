class_name InSimMSOPacket
extends InSimPacket

## MSg Out packet - system messages and user messages - variable size

const PACKET_MIN_SIZE := 12
const PACKET_MAX_SIZE := 136
const PACKET_TYPE := InSim.Packet.ISP_MSO
const MSG_MAX_LENGTH := 128

var zero := 0

var ucid := 0  ## connection's unique id (0 = host)
var player_id := 0  ## player's unique id (if zero, use [member ucid])
var user_type := 0  ## set if typed by a user (see [enum InSim.MessageUserValue])
var text_start := 0  ## first character of the actual text (after player name)
var msg := ""  ## 4, 8, 12... 128 characters - last byte is zero


func _init() -> void:
	size = PACKET_MAX_SIZE
	type = PACKET_TYPE


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if (
		packet_size < PACKET_MIN_SIZE
		or packet_size > PACKET_MAX_SIZE
		or packet_size % SIZE_MULTIPLIER != 0
	):
		push_error("%s packet expected size [%d..%d step %d], got %d." % [InSim.Packet.keys()[type],
				PACKET_MIN_SIZE, PACKET_MAX_SIZE, SIZE_MULTIPLIER, packet_size])
		return
	super(packet)
	zero = read_byte()
	ucid = read_byte()
	player_id = read_byte()
	user_type = read_byte()
	text_start = read_byte()
	msg = read_string(packet_size - data_offset)


func _get_data_dictionary() -> Dictionary:
	return {
		"Zero": zero,
		"UCID": ucid,
		"PLID": player_id,
		"UserType": user_type,
		"TextStart": text_start,
		"Msg": msg,
	}
