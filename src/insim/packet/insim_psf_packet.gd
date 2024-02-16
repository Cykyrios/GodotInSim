class_name InSimPSFPacket
extends InSimPacket

## Pit Stop Finished packet

const PACKET_SIZE := 12
const PACKET_TYPE := InSim.Packet.ISP_PSF
var player_id := 0  ## player's unique id

var stop_time := 0  ## stop time (ms)
var spare := 0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	player_id = read_byte()
	stop_time = read_unsigned()
	spare = read_unsigned()


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": player_id,
		"StopTime": stop_time,
		"Spare": spare,
	}
