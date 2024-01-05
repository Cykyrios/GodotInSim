class_name OutSimPacket
extends LFSPacket


func _init(packet := PackedByteArray()) -> void:
	if not packet.is_empty():
		decode_packet(packet)


func _to_string() -> String:
	return "%s" % [buffer]


func _decode_packet(packet_buffer: PackedByteArray) -> void:
	super(packet_buffer)
