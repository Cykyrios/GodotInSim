class_name OutSimPacket
extends LFSPacket


const SIZE_WITHOUT_ID := 64
const SIZE_WITH_ID := 68

var time := 0
var ang_vel := Vector3.ZERO
var heading := 0.0
var pitch := 0.0
var roll := 0.0
var accel := Vector3.ZERO
var vel := Vector3.ZERO
var pos := Vector3i.ZERO
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
	ang_vel.x = read_float(packet)
	ang_vel.y = read_float(packet)
	ang_vel.z = read_float(packet)
	heading = read_float(packet)
	pitch = read_float(packet)
	roll = read_float(packet)
	accel.x = read_float(packet)
	accel.y = read_float(packet)
	accel.z = read_float(packet)
	vel.x = read_float(packet)
	vel.y = read_float(packet)
	vel.z = read_float(packet)
	pos.x = read_int(packet)
	pos.y = read_int(packet)
	pos.z = read_int(packet)
	if packet_size == SIZE_WITH_ID:
		id = read_int(packet)
