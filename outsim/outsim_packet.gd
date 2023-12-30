class_name OutSimPacket
extends RefCounted


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
	time = packet.decode_u32(0)
	ang_vel = Vector3(packet.decode_float(4), packet.decode_float(8), packet.decode_float(12))
	heading = packet.decode_float(16)
	pitch = packet.decode_float(20)
	roll = packet.decode_float(24)
	accel = Vector3(packet.decode_float(28), packet.decode_float(32), packet.decode_float(36))
	vel = Vector3(packet.decode_float(40), packet.decode_float(44), packet.decode_float(48))
	pos = Vector3i(packet.decode_u32(52), packet.decode_u32(56), packet.decode_u32(60))
	if packet_size == SIZE_WITH_ID:
		id = packet.decode_u32(SIZE_WITHOUT_ID)
