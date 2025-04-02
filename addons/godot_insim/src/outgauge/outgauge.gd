class_name OutGauge
extends Node


signal packet_received(packet: OutGaugePacket)

var lfs_connection := LFSConnectionUDP.new()


func _ready() -> void:
	add_child(lfs_connection)
	var _discard := lfs_connection.packet_received.connect(_on_packet_received)


static func create_packet_from_buffer(packet_buffer: PackedByteArray) -> OutGaugePacket:
	var packet := OutGaugePacket.new()
	packet.buffer = packet_buffer
	packet.decode_packet(packet_buffer)
	return packet


func close() -> void:
	lfs_connection.disconnect_from_host()


func initialize(address := "127.0.0.1", port := 29_998) -> void:
	lfs_connection.connect_to_host(address, port, 0, true)


func _on_packet_received(packet_buffer: PackedByteArray) -> void:
	var packet := OutGauge.create_packet_from_buffer(packet_buffer)
	packet_received.emit(packet as OutGaugePacket)
