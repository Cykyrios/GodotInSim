class_name InSimPSFPacket
extends InSimPacket
## Pit Stop Finished packet
##
## This packet is received when a player leaves their pit box after a pit stop.

## Conversion factor between standard units and LFS-encoded values.
const TIME_MULTIPLIER := 1000.0

const PACKET_SIZE := 12  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_PSF  ## The packet's type, see [enum InSim.Packet].
var plid := 0  ## Player's unique id

var stop_time := 0  ## Stop time (ms)
var spare := 0  ## Spare

var gis_stop_time := 0.0  ## Stop time in seconds


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	receivable = true


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [get_type_string(), size, packet_size])
		return
	super(packet)
	plid = read_byte()
	stop_time = read_unsigned()
	spare = read_unsigned()


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": plid,
		"StopTime": stop_time,
	}


func _get_pretty_text() -> String:
	return "PLID %d stopped for %ss" % [plid,
			GISTime.get_time_string_from_seconds(gis_stop_time, 3, true)]


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(dict, ["PLID", "StopTime"]):
		return
	plid = dict["PLID"]
	stop_time = dict["StopTime"]


func _update_gis_values() -> void:
	gis_stop_time = stop_time / TIME_MULTIPLIER
