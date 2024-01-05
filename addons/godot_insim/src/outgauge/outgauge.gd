class_name OutGauge
extends Node


signal packet_received(packet: OutGaugePacket)

const PACKET_READ_INTERVAL := 0.01

var address := "127.0.0.1"
var port := 29_998

var socket: PacketPeerUDP = null
var packet_timer := 0.0


func _ready() -> void:
	socket = PacketPeerUDP.new()


func _process(delta: float) -> void:
	packet_timer += delta
	if delta >= PACKET_READ_INTERVAL:
		packet_timer = 0
		read_incoming_packets()


static func create_packet_from_buffer(packet_buffer: PackedByteArray) -> OutGaugePacket:
	var packet := OutGaugePacket.new()
	packet.buffer = packet_buffer
	packet.decode_packet(packet_buffer)
	return packet


func close() -> void:
	if not socket:
		return
	socket.close()


func initialize() -> void:
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
		var outgauge_packet := OutGauge.create_packet_from_buffer(packet_buffer)
		packet_received.emit(outgauge_packet)
