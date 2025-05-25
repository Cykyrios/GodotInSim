class_name InSimOBHPacket
extends InSimPacket
## OBject Hit packet - car hit an autocross object or an unknown object
##
## This packet is received when a player hits an object.

## Hit flags
enum Flag {
	OBH_LAYOUT = 1,  ## an added object
	OBH_CAN_MOVE = 2,  ## a movable object
	OBH_WAS_MOVING = 4,  ## was moving before this hit
	OBH_ON_SPOT = 8,  ## object in original position
}

const _CLOSING_SPEED_MASK := 0x0fff

## Conversion factor between standard units and LFS-encoded values.
const CLOSING_SPEED_MULTIPLIER := 10.0
## Conversion factor between standard units and LFS-encoded values.
const POSITION_XY_MULTIPLIER := 16.0
## Conversion factor between standard units and LFS-encoded values.
const POSITION_Z_MULTIPLIER := 4.0

const PACKET_SIZE := 24  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_OBH  ## The packet's type, see [enum InSim.Packet].
var plid := 0  ## Player's unique id

var sp_close := 0  ## high 4 bits: reserved / low 12 bits: closing speed (10 = 1 m/s)
var time := 0  ## looping time stamp (hundredths - time since reset - like [constant InSim.TINY_GTH])

var object := CarContObj.new()  ## Details about the car that hit the object

var x := 0  ## as in [ObjectInfo]
var y := 0  ## as in [ObjectInfo]

var z := 0  ## if [constant Flag.OBH_LAYOUT] is set: as in [ObjectInfo]
var sp1 := 0  ## Spare
var index := 0  ## AXO_x as in [ObjectInfo] or zero if it is an unknown object
var obh_flags := 0  ## Flags, see [enum Flag]

var gis_closing_speed := 0.0  ## Closing speed in m/s
var gis_position := Vector3.ZERO  ## Position in meters


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
	sp_close = read_word()
	time = read_word()
	var struct_size := CarContObj.STRUCT_SIZE
	object.set_from_buffer(packet.slice(data_offset, data_offset + struct_size))
	data_offset += struct_size
	x = read_short()
	y = read_short()
	z = read_byte()
	sp1 = read_byte()
	index = read_byte()
	obh_flags = read_byte()


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": plid,
		"SpClose": sp_close,
		"Time": time,
		"C": object,
		"X": x,
		"Y": y,
		"Z": z,
		"Sp1": sp1,
		"Index": index,
		"OBHFlags": obh_flags,
	}


func _get_pretty_text() -> String:
	var flags: Array[String] = []
	for i in InSim.OBHFlag.size():
		if obh_flags & InSim.OBHFlag.values()[i]:
			flags.append(InSim.OBHFlag.keys()[i])
	return "PLID %d hit an object: %s (%s) at coordinates %.1v (closing speed %s m/s)" % [plid,
			InSim.AXOIndex.keys()[index], flags, gis_position, gis_closing_speed]


func _update_gis_values() -> void:
	gis_closing_speed = (sp_close & _CLOSING_SPEED_MASK) / CLOSING_SPEED_MULTIPLIER
	gis_position = Vector3(x / POSITION_XY_MULTIPLIER, y / POSITION_XY_MULTIPLIER,
			z / POSITION_Z_MULTIPLIER)
