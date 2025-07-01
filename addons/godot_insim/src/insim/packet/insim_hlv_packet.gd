class_name InSimHLVPacket
extends InSimPacket
## Hot Lap Validity packet - off track / hit wall / speeding in pits / out of bounds
##
## This packet is received when a player violates the hotlap validity rules.

## Conversion factor between standard units and LFS-encoded values.
const TIME_MULTIPLIER := 100.0

const PACKET_SIZE := 16  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_HLV  ## The packet's type, see [enum InSim.Packet].
var plid := 0  ## player's unique id

var hlvc := 0  ## 0: ground / 1: wall / 4: speeding / 5: out of bounds
var sp1 := 0  ## Sapre
## looping time stamp (hundredths - time since reset - like [constant InSim.Tiny.TINY_GTH])
var time := 0

var object := CarContObj.new()  ## Details about the car that violated HLV rules.

var gis_time := 0.0  ## Time in seconds


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
	hlvc = read_byte()
	sp1 = read_byte()
	time = read_word()
	var struct_size := CarContObj.STRUCT_SIZE
	object.set_from_buffer(packet.slice(data_offset, data_offset + struct_size))
	data_offset += struct_size


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": plid,
		"HLVC": hlvc,
		"Time": time,
		"C": object.get_dictionary(),
	}


func _get_pretty_text() -> String:
	return "PLID %d: invalid hotlap (%s at coordinates %.1v)" % [plid, "ground" if hlvc == 0 \
			else "wall" if hlvc == 1 else "speeding" if hlvc == 4 \
			else "out of bounds" if hlvc == 5 else "?", object.gis_position]


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(dict, ["PLID", "HLVC", "Time", "C"]):
		return
	plid = dict["PLID"]
	hlvc = dict["HLVC"]
	time = dict["Time"]
	object.set_from_dictionary(dict["C"] as Dictionary)


func _update_gis_values() -> void:
	gis_time = time / TIME_MULTIPLIER
