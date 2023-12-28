class_name OutGaugePacket
extends RefCounted


enum OGFlags {
	OG_SHIFT = 1,
	OG_CTRL = 2,
	OG_TURBO = 8192,
	OG_KM = 16384,
	OG_BAR = 32768,
}

enum DLFlags {
	DL_SHIFT,
	DL_FULLBEAM,
	DL_HANDBRAKE,
	DL_PITSPEED,
	DL_TC,
	DL_SIGNAL_L,
	DL_SIGNAL_R,
	DL_SIGNAL_ANY,
	DL_OILWARN,
	DL_BATTERY,
	DL_ABS,
	DL_ENGINE,
	DL_FOG_REAR,
	DL_FOG_FRONT,
	DL_DIPPED,
	DL_FUELWARN,
	DL_SIDELIGHTS,
	DL_NEUTRAL,
	DL_18,
	DL_19,
	DL_20,
	DL_21,
	DL_22,
	DL_23,
	DL_NUM,
}

const SIZE_WITHOUT_ID := 92
const SIZE_WITH_ID := 96

var time := 0
var car_name := ""
var flags := 0
var gear := 0
var player_id := 0
var speed := 0.0
var rpm := 0.0
var turbo := 0.0
var engine_temp := 0.0
var fuel := 0.0
var oil_pres := 0.0
var oil_temp := 0.0
var dash_lights := 0
var show_lights := 0
var throttle := 0.0
var brake := 0.0
var clutch := 0.0
var display1 := ""
var display2 := ""
var id := 0


func _init(packet := PackedByteArray()) -> void:
	if not packet.is_empty():
		decode_packet(packet)


func decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != SIZE_WITHOUT_ID and packet_size != SIZE_WITH_ID:
		push_error("OutGauge packet size incorrect: expected %d or %d, got %d." % \
				[SIZE_WITHOUT_ID, SIZE_WITH_ID, packet_size])
		return
	time = packet.decode_u32(0)
	car_name = packet.slice(4, 8).get_string_from_utf8()
	flags = packet.decode_u16(8)
	gear = packet.decode_u8(10)
	player_id = packet.decode_u8(11)
	speed = packet.decode_float(12)
	rpm = packet.decode_float(16)
	turbo = packet.decode_float(20)
	engine_temp = packet.decode_float(24)
	fuel = packet.decode_float(28)
	oil_pres = packet.decode_float(32)
	oil_temp = packet.decode_float(36)
	dash_lights = packet.decode_u32(40)
	show_lights = packet.decode_u32(44)
	throttle = packet.decode_float(48)
	brake = packet.decode_float(52)
	clutch = packet.decode_float(56)
	display1 = packet.slice(60, 76).get_string_from_utf8()
	display2 = packet.slice(76, 92).get_string_from_utf8()
	if packet_size == SIZE_WITH_ID:
		id = packet.decode_u32(SIZE_WITHOUT_ID)


func get_flags_array() -> Array[int]:
	var flags_array: Array[int] = []
	flags_array.resize(OGFlags.size())
	for i in flags_array.size():
		flags_array[i] = 1 if flags & OGFlags.values()[i] > 0 else 0
	return flags_array


func get_lights_array(lights: int) -> Array[int]:
	var lights_array: Array[int] = []
	lights_array.resize(DLFlags.size() - 1)
	for i in lights_array.size():
		lights_array[i] = (lights >> i) & 1
	return lights_array
