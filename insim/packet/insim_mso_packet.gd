class_name InSimMSOPacket
extends InSimPacket


const PACKET_MIN_SIZE := 12
const PACKET_MAX_SIZE := 136
const MSG_MAX_LENGTH := 128

var ucid := 0
var player_id := 0
var user_type := 0
var text_start := 0
var msg := ""


func _init() -> void:
	size = PACKET_MAX_SIZE
	type = InSim.Packet.ISP_MSO
	super()


func _get_data_dictionary() -> Dictionary:
	var data := {
		"UCID": ucid,
		"PLID": player_id,
		"UserType": user_type,
		"TextStart": text_start,
		"Msg": msg,
	}
	return data


func _decode_packet(packet: PackedByteArray) -> void:
	super(packet)
	var packet_size := packet.size()
	if packet_size < PACKET_MIN_SIZE or packet_size > PACKET_MAX_SIZE or packet_size % 4 != 0:
		push_error("ISP_MSO packet expected size [%d..%d step %d], got %d." % \
				[PACKET_MIN_SIZE, PACKET_MAX_SIZE, 4, packet_size])
		return
	ucid = read_byte(packet)
	player_id = read_byte(packet)
	user_type = read_byte(packet)
	text_start = read_byte(packet)
	msg = read_string(packet, packet_size - data_offset)
