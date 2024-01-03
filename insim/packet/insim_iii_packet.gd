class_name InSimIIIPacket
extends InSimPacket


const PACKET_MIN_SIZE := 12
const PACKET_MAX_SIZE := 72
const PACKET_TYPE := InSim.Packet.ISP_III
const MSG_MAX_LENGTH := 64

var zero := 0

var ucid := 0
var player_id := 0
var sp2 := 0
var sp3 := 0

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
	sp2 = read_byte(packet)
	sp3 = read_byte(packet)
	msg = read_string(packet, packet_size - data_offset)


func _get_data_dictionary() -> Dictionary:
	return {
		"Zero": zero,
		"UCID": ucid,
		"PLID": player_id,
		"Sp2": sp2,
		"Sp3": sp3,
		"Msg": msg,
	}
