class_name RelayHOSPacket
extends InSimRelayPacket
## Relay host list packet
##
## This packet is received after a host list request with [RelayHLRPacket].

const PACKET_BASE_SIZE := 4  ## Packet base size
const PACKET_TYPE := InSim.Packet.IRP_HOS  ## The packet's type, see [enum InSim.Packet].
const MIN_HOST_INFO := 1  ## Minimum host info number per packet
const MAX_HOST_INFO := 6  ## Maximum host info number per packet

var num_hosts := 0  ## Number of host info in this packet
var host_info: Array[HostInfo] = []  ## Array of host info


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
		push_error("%s packet expected size [%d..%d step %d], got %d." % [
			get_type_string(), min_size, max_size, SIZE_MULTIPLIER, packet_size
		])
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
