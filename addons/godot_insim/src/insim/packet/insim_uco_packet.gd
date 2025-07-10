class_name InSimUCOPacket
extends InSimPacket
## User Control Object packet
##
## This packet is received when a player crosses a checkpoint or enters/leaves a circle.

## Conversion factor between standard units and LFS-encoded values.
const TIME_MULTIPLIER := 100.0

const PACKET_SIZE := 28  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_UCO  ## The packet's type, see [enum InSim.Packet].
var plid := 0  ## Player's unique id

var sp0 := 0  ## Spare
var uco_action := InSim.UCOAction.UCO_CIRCLE_ENTER  ## UCO Action, see [enum InSim.UCOAction].
var sp2 := 0  ## Spare
var sp3 := 0  ## Spare

var time := 0  ## Hundredths of a second since start (as in [constant InSim.Small.SMALL_RTP])
var object := CarContObj.new()  ## Info about the car
var info := ObjectInfo.new()  ## Info about the checkpoint or circle

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
		"UCOAction": uco_action,
		"Time": time,
		"C": object.get_dictionary(),
		"Info": info.get_dictionary(),
	}


func _get_pretty_text() -> String:
	var checkpoint_id := 0
	if uco_action in [InSim.UCOAction.UCO_CP_FWD, InSim.UCOAction.UCO_CP_REV]:
		if info.index == 252:
			checkpoint_id = info.flags & 0b11
	var action_string := "%s circle %d" % [
		"entered" if uco_action == InSim.UCOAction.UCO_CIRCLE_ENTER else "exited", info.heading
	] if (
		uco_action in [InSim.UCOAction.UCO_CIRCLE_ENTER, InSim.UCOAction.UCO_CIRCLE_LEAVE]
	) else "crossed checkpoint %d%s at %.1v" % [
		checkpoint_id,
		"" if uco_action == InSim.UCOAction.UCO_CP_FWD else " backward",
		info.gis_position,
	]
	return "PLID %d %s" % [plid, action_string]


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(dict, ["PLID", "UCOAction", "Time", "C", "Info"]):
		return
	plid = dict["PLID"]
	uco_action = dict["UCOAction"]
	time = dict["Time"]
	object.set_from_dictionary(dict["C"] as Dictionary)
	info.set_from_dictionary(dict["Info"] as Dictionary)


func _update_gis_values() -> void:
	gis_time = time / TIME_MULTIPLIER
