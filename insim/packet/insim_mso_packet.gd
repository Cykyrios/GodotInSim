class_name InSimMSOPacket
extends InSimPacket


const PACKET_MIN_SIZE := 12
const PACKET_MAX_SIZE := 136
const PACKET_TYPE := InSim.Packet.ISP_MSO
const MSG_MAX_LENGTH := 128

var zero := 0

var ucid := 0
var player_id := 0
var user_type := 0
var text_start := 0
var msg := ""


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
	zero = read_byte(packet)
	ucid = read_byte(packet)
	player_id = read_byte(packet)
	user_type = read_byte(packet)
	text_start = read_byte(packet)
	msg = read_string(packet, packet_size - data_offset)


func _get_data_dictionary() -> Dictionary:
	return {
		"Zero": zero,
		"UCID": ucid,
		"PLID": player_id,
		"UserType": user_type,
		"TextStart": text_start,
		"Msg": msg,
	}
