class_name LFSConnectionUDP
extends LFSConnection


var socket := PacketPeerUDP.new()


func connect_to_host(_address: String, _port: int, _udp_port := 0, is_out := false) -> void:
	super(_address, _port, _udp_port)
	var error := -1
	# I honestly have no idea why I have to do this, but socket.connect_to_host() doesn't work for
	# OutGauge/OutSim, packets aren't received. OTOH, socket.bind() returns 2 for InSim...
	if is_out:
		error = socket.bind(port, address)
	else:
		error = socket.connect_to_host(address, port)
	if error == OK:
		connected.emit()
	else:
		push_error("Connection error: %d" % [error])
		connection_failed.emit()


func disconnect_from_host() -> void:
	socket.close()


func get_incoming_packets() -> void:
	var packet_buffer := PackedByteArray()
	while socket.get_available_packet_count() > 0:
		packet_buffer = socket.get_packet()
		var error := socket.get_packet_error()
		if error != OK:
			push_error("Error reading incoming packet: %s" % [error])
			continue
		packet_received.emit(packet_buffer)


func send_packet(packet: PackedByteArray) -> bool:
	if not socket.is_socket_connected():
		await connected
	var error := socket.put_packet(packet)
	if error != OK:
		push_error("Error sending packet: %d" % [error])
		return false
	return true
