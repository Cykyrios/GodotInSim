class_name InSimCONPacket
extends InSimPacket
## CONtact packet - between two cars ([member car_a] and [member car_b] are sorted by PLID)
##
## This packet is received when two cars collide.

const _CLOSING_SPEED_MASK := 0x0fff

## Conversion factor between standard units and LFS-encoded values.
const CLOSING_SPEED_MULTIPLIER := 10.0
## Conversion factor between standard units and LFS-encoded values.
const TIME_MULTIPLIER := 100.0

const PACKET_SIZE := 40  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_CON  ## The packet's type, see [enum InSim.Packet].

var zero := 0  ## Zero byte

var sp_close := 0  ## high 4 bits: reserved / low 12 bits: closing speed (10 = 1 m/s)
## looping time stamp (hundredths - time since reset - like [constant InSim.Tiny.TINY_GTH]
var time := 0

var car_a := CarContact.new()  ## Car contact data for the first car.
var car_b := CarContact.new()  ## Car contact data for the second car.

var gis_closing_speed := 0.0  ## Closing speed in m/s
var gis_time := 0.0  ## Time in s


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
	zero = read_byte()
	sp_close = read_word()
	time = read_word()
	var struct_size := CarContact.STRUCT_SIZE
	car_a.set_from_buffer(packet.slice(data_offset, data_offset + struct_size))
	data_offset += struct_size
	car_b.set_from_buffer(packet.slice(data_offset, data_offset + struct_size))
	data_offset += struct_size


func _get_data_dictionary() -> Dictionary:
	return {
		"Zero": zero,
		"SpClose": sp_close,
		"Time": time,
		"A": car_a,
		"B": car_b,
	}


func _get_pretty_text() -> String:
	return "Contact between PLID %d and PLID %d at coordinates %.1v (closing speed %s m/s)" % \
			[car_a.plid, car_b.plid, 0.5 * (car_a.gis_position + car_b.gis_position),
			gis_closing_speed]


func _update_gis_values() -> void:
	gis_closing_speed = (sp_close & _CLOSING_SPEED_MASK) / CLOSING_SPEED_MULTIPLIER
	gis_time = time / TIME_MULTIPLIER
