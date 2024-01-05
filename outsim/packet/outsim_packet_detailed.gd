class_name OutSimPacketDetailed
extends OutSimPacket

var outsim_options := 0
var outsim_pack := OutSimPack2.new()


func _init(options: int, packet := PackedByteArray()) -> void:
	outsim_options = options
	if not packet.is_empty():
		decode_packet(packet)


func _to_string() -> String:
	return "%s" % [buffer]


func _decode_packet(packet: PackedByteArray) -> void:
	outsim_pack.os_options = outsim_options
	outsim_pack.set_from_buffer(packet)
