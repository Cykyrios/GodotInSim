class_name InSimCCHPacket
extends InSimPacket

## Camera CHange packet
##
## To track cameras you need to consider 3 points:[br]
## 1) The default camera: [constant InSim.VIEW_DRIVER][br]
## 2) Player flags: [constant InSim.PIF_CUSTOM_VIEW] means [constant InSim.VIEW_CUSTOM]
## at start or pit exit[br]
## 3) IS_CCH ([InSimCCHPacket]): sent when an existing driver changes camera

const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_CCH
var player_id := 0  ## player's unique id

var camera := InSim.View.VIEW_MAX  ## view identifier (see [enum InSim.View])
var sp1 := 0
var sp2 := 0
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
	player_id = read_byte()
	camera = read_byte() as InSim.View
	sp1 = read_byte()
	sp2 = read_byte()
	sp3 = read_byte()


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": player_id,
		"Camera": camera,
		"Sp1": sp1,
		"Sp2": sp2,
		"Sp3": sp3,
	}
