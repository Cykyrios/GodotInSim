class_name InSimHLVPacket
extends InSimPacket

## Hot Lap Validity packet - off track / hit wall / speeding in pits / out of bounds

const TIME_MULTIPLIER := 100.0

const PACKET_SIZE := 16
const PACKET_TYPE := InSim.Packet.ISP_HLV
var player_id := 0  ## player's unique id

var hlvc := 0  ## 0: ground / 1: wall / 4: speeding / 5: out of bounds
var sp1 := 0
var time := 0  ## looping time stamp (hundredths - time since reset - like [constant InSim.TINY_GTH])

var object := CarContObj.new()

var gis_time := 0.0


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
	hlvc = read_byte()
	sp1 = read_byte()
	time = read_word()
	var struct_size := CarContObj.STRUCT_SIZE
	object.set_from_buffer(packet.slice(data_offset, data_offset + struct_size))
	data_offset += struct_size


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": player_id,
		"HLVC": hlvc,
		"Sp1": sp1,
		"Time": time,
		"C": object,
	}


func _update_gis_values() -> void:
	gis_time = time / TIME_MULTIPLIER
