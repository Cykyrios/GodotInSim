class_name InSimHLVPacket
extends InSimPacket


const PACKET_SIZE := 16
const PACKET_TYPE := InSim.Packet.ISP_HLV
var player_id := 0

var hlvc := 0
var sp1 := 0
var time := 0

var object := CarContObj.new()


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
	hlvc = read_byte(packet)
	sp1 = read_byte(packet)
	time = read_word(packet)
	var struct_size := CarContObj.STRUCT_SIZE
	object.set_from_buffer(packet.slice(data_offset, data_offset + struct_size))
	data_offset += struct_size


func _get_data_dictionary() -> Dictionary:
	var data := {
		"PLID": player_id,
		"HLVC": hlvc,
		"Sp1": sp1,
		"Time": time,
		"C": object,
	}
	return data
