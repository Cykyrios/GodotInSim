class_name OutGaugePacket
extends LFSPacket

## OutGauge packet


enum OGFlags {
	OG_SHIFT = 1,  ## key
	OG_CTRL = 2,  ## key
	OG_TURBO = 8192,  ## show turbo gauge
	OG_KM = 16384,  ## if not set - user prefers MILES
	OG_BAR = 32768,  ## if not set - user prefers PSI
}
enum DLFlags {
	DL_SHIFT,  ## bit 0 - shift light
	DL_FULLBEAM,  ## bit 1 - full beam
	DL_HANDBRAKE,  ## bit 2 - handbrake
	DL_PITSPEED,  ## bit 3 - pit speed limiter
	DL_TC,  ## bit 4 - TC active or switched off
	DL_SIGNAL_L,  ## bit 5 - left turn signal
	DL_SIGNAL_R,  ## bit 6 - right turn signal
	DL_SIGNAL_ANY,  ## bit 7 - shared turn signal
	DL_OILWARN,  ## bit 8 - oil pressure warning
	DL_BATTERY,  ## bit 9 - battery warning
	DL_ABS,  ## bit 10 - ABS active or switched off
	DL_ENGINE,  ## bit 11 - engine damage
	DL_FOG_REAR,  ## bit 12
	DL_FOG_FRONT,  ## bit 13
	DL_DIPPED,  ## bit 14 - dipped headlight symbol
	DL_FUELWARN,  ## bit 15 - low fuel warning light
	DL_SIDELIGHTS,  ## bit 16 - sidelights symbol
	DL_NEUTRAL,  ## bit 17 - neutral light
	DL_18,
	DL_19,
	DL_20,
	DL_21,
	DL_22,
	DL_23,
	DL_NUM
}

const DLF_ENGINE_SEVERE := 0x1000_0000  ## set if engine damage is severe

const DISPLAY_1_SIZE := 16
const DISPLAY_2_SIZE := 16

const SIZE_WITHOUT_ID := 92
const SIZE_WITH_ID := SIZE_WITHOUT_ID + 4

var time := 0  ## time in milliseconds (to check order)
var car_name := ""  ## Car name
var flags := 0  ## Info (see [enum OGFlags])
var gear := 0  ## Reverse:0, Neutral:1, First:2...
var player_id := 0  ## Unique ID of viewed player (0 = none)
var speed := 0.0  ## M/S
var rpm := 0.0  ## RPM
var turbo := 0.0  ## BAR
var engine_temp := 0.0  ## C
var fuel := 0.0  ## 0 to 1
var oil_pres := 0.0  ## BAR
var oil_temp := 0.0  ## C
var dash_lights := 0  ## Dash lights available (see [enum DLFlags])
var show_lights := 0  ## Dash lights currently switched on (same format as [member dash_lights])
var throttle := 0.0  ## 0 to 1
var brake := 0.0  ## 0 to 1
var clutch := 0.0  ## 0 to 1
var display1 := ""  ## Usually Fuel
var display2 := ""  ## Usually Settings
var id := 0  ## optional - only if OutGauge ID is specified


func _init(packet := PackedByteArray()) -> void:
	if not packet.is_empty():
		decode_packet(packet)


func decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != SIZE_WITHOUT_ID and packet_size != SIZE_WITH_ID:
		push_error("OutGauge packet size incorrect: expected %d or %d, got %d." % \
				[SIZE_WITHOUT_ID, SIZE_WITH_ID, packet_size])
		return
	time = read_unsigned()
	car_name = read_car_name()
	flags = read_word()
	gear = read_byte()
	player_id = read_byte()
	speed = read_float()
	rpm = read_float()
	turbo = read_float()
	engine_temp = read_float()
	fuel = read_float()
	oil_pres = read_float()
	oil_temp = read_float()
	dash_lights = read_unsigned()
	show_lights = read_unsigned()
	throttle = read_float()
	brake = read_float()
	clutch = read_float()
	display1 = read_string(DISPLAY_1_SIZE)
	display2 = read_string(DISPLAY_2_SIZE)
	if packet_size == SIZE_WITH_ID:
		id = read_int()


## Returns an array of 0 and 1 values depending on flags set.
func get_flags_array() -> Array[int]:
	var flags_array: Array[int] = []
	var _discard := flags_array.resize(OGFlags.size())
	for i in flags_array.size():
		flags_array[i] = 1 if flags & OGFlags.values()[i] > 0 else 0
	return flags_array


## Returns an array of 0 and 1 values depending on dash lights available/currently turned on.
func get_lights_array(lights: int) -> Array[int]:
	var lights_array: Array[int] = []
	var _discard := lights_array.resize(DLFlags.size() - 1)
	for i in lights_array.size():
		lights_array[i] = (lights >> i) & 1
	return lights_array
