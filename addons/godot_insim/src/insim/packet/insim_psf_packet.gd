class_name InSimPSFPacket
extends InSimPacket

## Pit Stop Finished packet

const TIME_MULTIPLIER := 1000.0

const PACKET_SIZE := 12
const PACKET_TYPE := InSim.Packet.ISP_PSF
var plid := 0  ## player's unique id

var stop_time := 0  ## stop time (ms)
var spare := 0

var gis_stop_time := 0.0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	receivable = true


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	plid = read_byte()
	stop_time = read_unsigned()
	spare = read_unsigned()


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": plid,
		"StopTime": stop_time,
		"Spare": spare,
	}


func _get_pretty_text() -> String:
	return "PLID %d stopped for %ss" % [plid,
			GISUtils.get_time_string_from_seconds(gis_stop_time, 3, true)]


func _update_gis_values() -> void:
	gis_stop_time = stop_time / TIME_MULTIPLIER
