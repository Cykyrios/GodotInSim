class_name InSimMSOPacket
extends InSimPacket

## MSg Out packet - system messages and user messages - variable size

const PACKET_MIN_SIZE := 12
const PACKET_MAX_SIZE := 136
const PACKET_TYPE := InSim.Packet.ISP_MSO
const MSG_MAX_LENGTH := 128

var zero := 0

var ucid := 0  ## connection's unique id (0 = host)
var plid := 0  ## player's unique id (if zero, use [member ucid])
## set if typed by a user (see [enum InSim.MessageUserValue])
var user_type := InSim.MessageUserValue.MSO_SYSTEM
## @experimental: This property is unreliable, use [method LFSText.get_mso_start] instead.
## first character of the actual text (after player name)[br]
## Note:  If the sender's name contains non-latin or multi-byte characters, the count will be off.
var text_start := 0
var msg := ""  ## 4, 8, 12... 128 characters - last byte is zero


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
	user_type = read_byte() as InSim.MessageUserValue
	text_start = read_byte()
	msg = read_string(packet_size - data_offset)


func _get_data_dictionary() -> Dictionary:
	return {
		"Zero": zero,
		"UCID": ucid,
		"PLID": plid,
		"UserType": user_type,
		"TextStart": text_start,
		"Msg": msg,
	}


func _get_pretty_text() -> String:
	return "(%s) %s" % [InSim.MessageUserValue.keys()[user_type], msg]
