class_name RelayHOSPacket
extends InSimRelayPacket


const PACKET_BASE_SIZE := 4
const PACKET_TYPE := InSim.Packet.IRP_HOS
const MIN_HOST_INFO := 1
const MAX_HOST_INFO := 6

var num_hosts := 0
var host_info: Array[HostInfo] = []


func _init() -> void:
	size = PACKET_BASE_SIZE
	type = PACKET_TYPE
	receivable = true


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	var min_size := PACKET_BASE_SIZE + MIN_HOST_INFO * HostInfo.STRUCT_SIZE
	var max_size := PACKET_BASE_SIZE + MAX_HOST_INFO * HostInfo.STRUCT_SIZE
	if (
		packet_size < min_size
		or packet_size > max_size
		or packet_size % SIZE_MULTIPLIER != 0
	):
		push_error("%s packet expected size [%d..%d step %d], got %d." % [InSim.Packet.keys()[type],
				min_size, max_size, SIZE_MULTIPLIER, packet_size])
		return
	super(packet)
	host_info.clear()
	num_hosts = read_byte()
	for i in num_hosts:
		var host := HostInfo.new()
		host.set_from_buffer(packet.slice(data_offset, data_offset + HostInfo.STRUCT_SIZE))
		data_offset += HostInfo.STRUCT_SIZE
		host_info.append(host)


func _get_data_dictionary() -> Dictionary:
	return {
		"NumHosts": num_hosts,
		"Info": host_info,
	}
