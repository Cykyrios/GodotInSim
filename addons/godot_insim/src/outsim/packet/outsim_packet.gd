class_name OutSimPacket
extends LFSPacket
## OutSim packet
##
## Depending on the options set in the [code]cfg.txt[/code] file, LFS will send either an OutSimPack
## (OutSim Opts = 0) or a customizable OutSimPack2 (OSOpts > 0, up to 0x1ff, see
## [enum OutSim.OutSimOpts]). The approach with this implementation uses a single [OutSimPack]
## struct instead, corresponding by default to LFS's OutSimPack2, and fills it with the appropriate
## values depending on OutSim Opts, including [code]0[/code].

## The OutSim options from the [OutSim] object that sent this packet.
var outsim_options := 0
## The struct containing the OutSim data, depending on the [member outsim_options].
var outsim_pack := OutSimPack.new()


func _init(options: int, packet := PackedByteArray()) -> void:
	outsim_options = options
	if not packet.is_empty():
		decode_packet(packet)


func _to_string() -> String:
	return "%s" % [buffer]


func _decode_packet(packet_buffer: PackedByteArray) -> void:
	super(packet_buffer)
	outsim_pack.outsim_options = outsim_options
	outsim_pack.set_from_buffer(packet_buffer)
