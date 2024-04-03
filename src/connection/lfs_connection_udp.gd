class_name LFSConnectionUDP
extends LFSConnection


var socket := PacketPeerUDP.new()


func connect_to_host(_address: String, _port: int) -> void:
	super(_address, _port)
	var error := socket.connect_to_host(address, port)
	if error != OK:
		push_error("Connection error: %d" % [error])


func disconnect_from_host() -> void:
	socket.close()


func get_incoming_packets() -> void:
	var packet_buffer := PackedByteArray()
	var packet_type := InSim.Packet.ISP_NONE
	while socket.get_available_packet_count() > 0:
		packet_buffer = socket.get_packet()
		var error := socket.get_packet_error()
		if error != OK:
			push_error("Error reading incoming packet: %s" % [error])
			continue
		packet_type = packet_buffer.decode_u8(1) as InSim.Packet
		if packet_type != InSim.Packet.ISP_NONE:
			var insim_packet := InSimPacket.create_packet_from_buffer(packet_buffer)
			packet_received.emit(insim_packet)


func send_packet(packet: InSimPacket) -> void:
	packet.fill_buffer()
	var error := socket.put_packet(packet.buffer)
	if error != OK:
		push_error("Error sending packet: %d" % [error])
		return
	packet_sent.emit(packet)
