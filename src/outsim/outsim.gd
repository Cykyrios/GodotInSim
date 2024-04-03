class_name OutSim
extends Node


signal packet_received(packet: OutSimPacket)

enum OutSimOpts {
	OSO_HEADER = 1,
	OSO_ID = 2,
	OSO_TIME = 4,
	OSO_MAIN = 8,
	OSO_INPUTS = 16,
	OSO_DRIVE = 32,
	OSO_DISTANCE = 64,
	OSO_WHEELS = 128,
	OSO_EXTRA_1 = 256,
}

var outsim_options := 0

var lfs_connection := LFSConnectionUDP.new()


func _ready() -> void:
	add_child(lfs_connection)
	var _discard := lfs_connection.packet_received.connect(_on_packet_received)


static func create_packet_from_buffer(options: int, packet_buffer: PackedByteArray) -> OutSimPacket:
	var packet := OutSimPacket.new(options, packet_buffer)
	return packet


func close() -> void:
	lfs_connection.disconnect_from_host()


func initialize(options: int, address := "127.0.0.1", port := 29_997) -> void:
	outsim_options = options
	lfs_connection.connect_to_host(address, port, 0, true)


func _on_packet_received(packet_buffer: PackedByteArray) -> void:
	var packet := OutSim.create_packet_from_buffer(outsim_options, packet_buffer)
	packet_received.emit(packet)
