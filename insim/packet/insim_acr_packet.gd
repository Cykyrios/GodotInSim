class_name InSimACRPacket
extends InSimPacket


const PACKET_MIN_SIZE := 12
const PACKET_MAX_SIZE := 72
const PACKET_TYPE := InSim.Packet.ISP_ACR
const MSG_MAX_LENGTH := 64

var zero := 0

var ucid := 0
var admin := 0
var result := 0
var sp3 := 0

var text := ""


func _init() -> void:
	size = PACKET_MAX_SIZE
	type = PACKET_TYPE


func _get_data_dictionary() -> Dictionary:
	var data := {
		"Zero": zero,
		"UCID": ucid,
		"Admin": admin,
		"Result": result,
		"Sp3": sp3,
		"Text": text,
	}
	return data


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
	admin = read_byte(packet)
	result = read_byte(packet)
	sp3 = read_byte(packet)
	text = read_string(packet, packet_size - data_offset)