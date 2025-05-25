class_name IPAddress
extends InSimStruct
## IP address
##
## This class represents an IP address for use in [InSimIPBPacket].

const STRUCT_SIZE := 4  ## The size of this struct's data

var address_string := "0.0.0.0"  ## String representation of the IP address.
var address_array: PackedByteArray = [0, 0, 0, 0]  ## Array rerepsentation of the IP address.
var address_int := 0  ## Integer representation of the IP address.


func _to_string() -> String:
	return "IP address:%s" % [address_string]


func _get_buffer() -> PackedByteArray:
	var buffer := PackedByteArray()
	var _discard := buffer.resize(STRUCT_SIZE)
	buffer.append_array(address_array)
	return buffer


func _set_from_buffer(buffer: PackedByteArray) -> void:
	if buffer.size() != STRUCT_SIZE:
		push_error("Wrong buffer size, expected %d, got %d" % [STRUCT_SIZE, buffer.size()])
	fill_from_array(buffer)


## Sets the IP address from the given [param ip_array].
func fill_from_array(ip_array: PackedByteArray = [0, 0, 0, 0]) -> void:
	if ip_array.size() != 4:
		fill_from_array()
		return
	address_array.clear()
	for i in 4:
		var value := ip_array[i]
		if value < 0 or value > 255:
			value = 0
		var _discard := address_array.append(value)
	address_int = address_array.decode_u32(0)
	address_string = "%d.%d.%d.%d" % [address_array[0], address_array[1],
			address_array[2], address_array[3]]


## Sets the IP address from the given [param ip_int].
func fill_from_int(ip_int := 0) -> void:
	if ip_int < 0 or ip_int > 0xffff_ffff:
		fill_from_int()
		return
	address_int = ip_int
	address_array.clear()
	var _discard := address_array.resize(STRUCT_SIZE)
	address_array.encode_u32(0, ip_int)
	address_string = "%d.%d.%d.%d" % [address_array[0], address_array[1],
			address_array[2], address_array[3]]


## Sets the IP address from the given [param ip_string].
func fill_from_string(ip_string := "0.0.0.0") -> void:
	var regex := RegEx.create_from_string(r"(-?\d+).(-?\d+).(-?\d+).(-?\d+)")
	var result := regex.search(ip_string)
	if not result:
		fill_from_string()
		return
	address_string = ip_string
	address_array.clear()
	for i in 4:
		var value := result.strings[i + 1].to_int()
		if value < 0 or value > 255:
			value = 0
		var _discard := address_array.append(value)
	var packed_array := PackedByteArray(address_array)
	address_int = packed_array.decode_u32(0)
