class_name LFSConnectionTCP
extends LFSConnection


var stream := StreamPeerTCP.new()
var is_insim_relay := false


func connect_to_host(_address: String, _port: int, _udp_port := 0) -> void:
	super(_address, _port, _udp_port)
	if address == InSim.RELAY_ADDRESS and port == InSim.RELAY_PORT:
		is_insim_relay = true
	var error := stream.connect_to_host(address, port)
	if error != OK:
		push_error("Connection error: %d" % [error])
	var _discard := stream.poll()
	var status := stream.get_status()
	print("TCP connecting...")
	while status == stream.STATUS_CONNECTING:
		await get_tree().create_timer(0.5).timeout
		status = stream.get_status()
	var status_string := "connected" if status == stream.STATUS_CONNECTED \
			else "error" if status == stream.STATUS_ERROR else str(status)
	print("TCP status: %s%s" % [status_string, (" - %s:%d" % [stream.get_connected_host(),
			stream.get_connected_port()]) if status == stream.STATUS_CONNECTED else ""])
	if status == stream.STATUS_CONNECTED:
		connected.emit()
	else:
		connection_failed.emit()


func disconnect_from_host() -> void:
	stream.disconnect_from_host()


func get_incoming_packets() -> void:
	var packet_buffer := PackedByteArray()
	var _discard := stream.poll()
	if (
		stream.get_status() != stream.STATUS_CONNECTED
		or stream.get_available_bytes() < InSimPacket.HEADER_SIZE
	):
		return
	while stream.get_available_bytes() >= InSimPacket.HEADER_SIZE:
		var stream_data := stream.get_data(InSimPacket.HEADER_SIZE)
		_discard = stream_data[0] as Error
		var packet_header := stream_data[1] as PackedByteArray
		var packet_size := packet_header[0]
		if is_insim_relay:
			packet_header[0] = int(packet_size / float(InSimPacket.SIZE_MULTIPLIER))
		else:
			packet_size *= InSimPacket.SIZE_MULTIPLIER
		packet_buffer = packet_header.duplicate()
		packet_buffer.append_array(stream.get_data(packet_size - InSimPacket.HEADER_SIZE)[1] as PackedByteArray)
		packet_received.emit(packet_buffer)
		_discard = stream.poll()


func send_packet(packet: PackedByteArray) -> bool:
	if is_insim_relay:
		packet[0] = packet[0] * InSimPacket.SIZE_MULTIPLIER
	var error := stream.put_data(packet)
	if error != OK:
		push_error("Error sending packet: %d" % [error])
		return false
	return true
