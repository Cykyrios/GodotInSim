class_name OutSim
extends Node
## OutSim interface
##
## You can add an [OutSim] node to any scene to enable reading data from LFS.[br]
## [b]Note:[/b] OutSim requires some setup in the [code]cfg.txt[/code] file; you can find more
## details in the [code]docs/InSim.txt[/code] file, in the section pertaining to OutSim, as well as
## the [code]docs/OutSimPack.txt[/code] for packet details.

## Emitted when a packet is received. You should connect to this signal if you plan to use OutSim.
signal packet_received(packet: OutSimPacket)

## OutSim options, which determine what data is sent by LFS; refer to
## [code]docs/OutSimPack.txt[/code] for more details.
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

var outsim_options := 0  ## The current value for InSim options

var _lfs_connection := LFSConnectionUDP.new()


## Creates and returns an [OutSimPacket] from the given [param packet_buffer]. This method is
## not intended to be used directly, and is called automatically by an [OutSim] instance when it
## receives a raw packet.
static func create_packet_from_buffer(options: int, packet_buffer: PackedByteArray) -> OutSimPacket:
	var packet := OutSimPacket.new(options, packet_buffer)
	return packet


func _ready() -> void:
	add_child(_lfs_connection)
	var _discard := _lfs_connection.packet_received.connect(_on_packet_received)


## Closes the [OutSim] connection, disabling packet reading.[br]
## [b]Note:[/b] As OutSim data is transmitted over UDP, there is no connection per se; this simply
## means the [OutSim] instance will stop listening to packets.
func close() -> void:
	_lfs_connection._disconnect_from_host()


## Enables packet listening over UDP with the given [param address] and [param port].
func initialize(options: int, address := "127.0.0.1", port := 29_997) -> void:
	outsim_options = options
	_lfs_connection._connect_to_host(address, port, 0, true)


func _on_packet_received(packet_buffer: PackedByteArray) -> void:
	var packet := OutSim.create_packet_from_buffer(outsim_options, packet_buffer)
	packet_received.emit(packet)
