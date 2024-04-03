class_name LFSConnectionTCP
extends LFSConnection


var stream := StreamPeerTCP.new()
var is_insim_relay := false
var udp_connection := LFSConnectionUDP.new()


func connect_to_host(_address: String, _port: int) -> void:
	super(_address, _port)
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
	print("TCP status: %d%s" % [status, (" - %s:%d" % [stream.get_connected_host(),
			stream.get_connected_port()]) if status == stream.STATUS_CONNECTED else ""])
	if status == stream.STATUS_CONNECTED:
		connected.emit()
	else:
		connection_failed.emit()


func disconnect_from_host() -> void:
	stream.disconnect_from_host()


func get_incoming_packets() -> void:
	var packet_buffer := PackedByteArray()
	var packet_type := InSim.Packet.ISP_NONE
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
		packet_type = packet_header[1] as InSim.Packet
		packet_buffer = packet_header.duplicate()
		packet_buffer.append_array(stream.get_data(packet_size - InSimPacket.HEADER_SIZE)[1] as PackedByteArray)
		if packet_type != InSim.Packet.ISP_NONE:
			var insim_packet := InSimPacket.create_packet_from_buffer(packet_buffer)
			packet_received.emit(insim_packet)
		_discard = stream.poll()


func send_packet(packet: InSimPacket) -> void:
	packet.fill_buffer()
	if is_insim_relay:
		packet.buffer[0] = packet.buffer[0] * InSimPacket.SIZE_MULTIPLIER
	var error := stream.put_data(packet.buffer)
	if error != OK:
		push_error("Error sending packet: %d" % [error])
		return
	packet_sent.emit(packet)
