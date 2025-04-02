class_name InSimUCOPacket
extends InSimPacket

## User Control Object packet

const TIME_MULTIPLIER := 100.0

const PACKET_SIZE := 28
const PACKET_TYPE := InSim.Packet.ISP_UCO
var plid := 0  ## player's unique id

var sp0 := 0
var uco_action := InSim.UCOAction.UCO_CIRCLE_ENTER  ## see [enum InSim.UCOAction]
var sp2 := 0
var sp3 := 0

var time := 0  ## hundredths of a second since start (as in [constant InSim.SMALL_RTP])
var object := CarContObj.new()
var info := ObjectInfo.new()  ## info about the checkpoint or circle

var gis_time := 0.0


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
	sp0 = read_byte()
	uco_action = read_byte() as InSim.UCOAction
	sp2 = read_byte()
	sp3 = read_byte()
	time = read_unsigned()
	var struct_size := CarContObj.STRUCT_SIZE
	object.set_from_buffer(packet.slice(data_offset, data_offset + struct_size))
	data_offset += struct_size
	struct_size = ObjectInfo.STRUCT_SIZE
	info.set_from_buffer(packet.slice(data_offset, data_offset + struct_size))
	data_offset += struct_size


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": plid,
		"Sp0": sp0,
		"UCOAction": uco_action,
		"Sp2": sp2,
		"Sp3": sp3,
		"Time": time,
		"C": object,
		"Info": info,
	}


func _get_pretty_text() -> String:
	var checkpoint_id := 0
	if uco_action in [InSim.UCOAction.UCO_CP_FWD, InSim.UCOAction.UCO_CP_REV]:
		if info.index == 252:
			checkpoint_id = info.flags && 0b11
	var action_string := ("%s circle %d" % ["entered" if uco_action == \
			InSim.UCOAction.UCO_CIRCLE_ENTER else "exited", info.heading]) if uco_action in \
			[InSim.UCOAction.UCO_CIRCLE_ENTER, InSim.UCOAction.UCO_CIRCLE_LEAVE] \
			else "crossed checkpoint %d%s at %.1v" % [checkpoint_id,
			"" if uco_action == InSim.UCOAction.UCO_CP_FWD else " backward", info.gis_position]
	return "PLID %d %s" % [plid, action_string]


func _update_gis_values() -> void:
	gis_time = time / TIME_MULTIPLIER
