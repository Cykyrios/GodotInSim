class_name OutSimPacketSimple
extends OutSimPacket


var outsim_pack := OutSimPack.new()


func _init(packet := PackedByteArray()) -> void:
	if not packet.is_empty():
		decode_packet(packet)


func _to_string() -> String:
	return "%s" % [buffer]


func _decode_packet(packet: PackedByteArray) -> void:
	super(packet)
	outsim_pack.set_from_buffer(packet)
