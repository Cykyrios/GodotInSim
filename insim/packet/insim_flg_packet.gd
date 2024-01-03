class_name InSimFLGPacket
extends InSimPacket


const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_FLG
var player_id := 0

var off_on := 0
var flag := 0
var car_behind := 0
var sp3 := 0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	player_id = read_byte(packet)
	off_on = read_byte(packet)
	flag = read_byte(packet)
	car_behind = read_byte(packet)
	sp3 = read_byte(packet)


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": player_id,
		"OffOn": off_on,
		"Flag": flag,
		"CarBehind": car_behind,
		"Sp3": sp3,
	}
