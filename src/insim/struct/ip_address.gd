class_name IPAddress
extends InSimStruct


const STRUCT_SIZE := 4

var address: Array[int] = [0, 0, 0, 0]


func _to_string() -> String:
	return "IP address:%d.%d.%d.%d" % [address[0], address[1], address[2], address[3]]


func _get_buffer() -> PackedByteArray:
	var buffer := PackedByteArray()
	var _discard := buffer.resize(STRUCT_SIZE)
	buffer.encode_u8(0, address[0])
	buffer.encode_u8(1, address[1])
	buffer.encode_u8(2, address[2])
	buffer.encode_u8(3, address[3])
	return buffer


func _set_from_buffer(buffer: PackedByteArray) -> void:
	if buffer.size() != STRUCT_SIZE:
		push_error("Wrong buffer size, expected %d, got %d" % [STRUCT_SIZE, buffer.size()])
	address[0] = buffer.decode_u8(0)
	address[1] = buffer.decode_u8(1)
	address[2] = buffer.decode_u8(2)
	address[3] = buffer.decode_u8(3)
