class_name InSimPSFPacket
extends InSimPacket


const PACKET_SIZE := 12
const PACKET_TYPE := InSim.Packet.ISP_PSF
var player_id := 0

var stop_time := 0
var spare := 0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _get_data_dictionary() -> Dictionary:
	var data := {
		"PLID": player_id,
		"StopTime": stop_time,
		"Spare": spare,
	}
	return data


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	player_id = read_byte(packet)
	stop_time = read_unsigned(packet)
	spare = read_unsigned(packet)
