class_name OutGaugePacket
extends LFSPacket


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
	DL_NUM
}

const DLF_ENGINE_SEVERE := 0x1000_0000

const DISPLAY_1_SIZE := 16
const DISPLAY_2_SIZE := 16

const SIZE_WITHOUT_ID := 92
const SIZE_WITH_ID := SIZE_WITHOUT_ID + 4

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
	time = read_unsigned(packet)
	car_name = read_car_name(packet)
	flags = read_word(packet)
	gear = read_byte(packet)
	player_id = read_byte(packet)
	speed = read_float(packet)
	rpm = read_float(packet)
	turbo = read_float(packet)
	engine_temp = read_float(packet)
	fuel = read_float(packet)
	oil_pres = read_float(packet)
	oil_temp = read_float(packet)
	dash_lights = read_unsigned(packet)
	show_lights = read_unsigned(packet)
	throttle = read_float(packet)
	brake = read_float(packet)
	clutch = read_float(packet)
	display1 = read_string(packet, DISPLAY_1_SIZE)
	display2 = read_string(packet, DISPLAY_2_SIZE)
	if packet_size == SIZE_WITH_ID:
		id = read_int(packet)


func get_flags_array() -> Array[int]:
	var flags_array: Array[int] = []
	var _discard := flags_array.resize(OGFlags.size())
	for i in flags_array.size():
		flags_array[i] = 1 if flags & OGFlags.values()[i] > 0 else 0
	return flags_array


func get_lights_array(lights: int) -> Array[int]:
	var lights_array: Array[int] = []
	var _discard := lights_array.resize(DLFlags.size() - 1)
	for i in lights_array.size():
		lights_array[i] = (lights >> i) & 1
	return lights_array
