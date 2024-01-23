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

const PACKET_READ_INTERVAL := 0.01

var outsim_options := 0

var address := "127.0.0.1"
var port := 29_997

var socket: PacketPeerUDP = null
var packet_timer := 0.0


func _ready() -> void:
	socket = PacketPeerUDP.new()


func _process(delta: float) -> void:
	packet_timer += delta
	if delta >= PACKET_READ_INTERVAL:
		packet_timer = 0
		read_incoming_packets()


static func create_packet_from_buffer(options: int, packet_buffer: PackedByteArray) -> OutSimPacket:
	var packet := OutSimPacket.new(options, packet_buffer)
	return packet


func close() -> void:
	if not socket:
		return
	socket.close()


func initialize(options: int) -> void:
	outsim_options = options
	var error := socket.bind(port, address)
	if error != OK:
		push_error(error)


func read_incoming_packets() -> void:
	var packet_buffer := PackedByteArray()
	while socket.get_available_packet_count() > 0:
		packet_buffer = socket.get_packet()
		var err := socket.get_packet_error()
		if err != OK:
			push_error("Error reading incoming packet: %s" % [err])
			continue
		var outsim_packet := OutSim.create_packet_from_buffer(outsim_options, packet_buffer)
		packet_received.emit(outsim_packet)
