class_name InSimNCIPacket
extends InSimPacket
## New Conn Info packet - sent on host only if an admin password has been set
##
## This packet is received by the host when a player connects to the server.

const PACKET_SIZE := 16  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_NCI  ## The packet's type, see [enum InSim.Packet].
var ucid := 0  ## Connection's unique id (0 = host)

var language := InSim.Language.LFS_ENGLISH  ## Language (see [enum InSim.Language])
var license := 0  ## Player license (0:demo / 1:S1 ...)
var sp2 := 0  ## Spare
var sp3 := 0  ## Spare

var user_id := 0  ## LFS UserID
var ip_address := IPAddress.new()  ## Player's IP address


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	receivable = true


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [get_type_string(), size, packet_size])
		return
	super(packet)
	ucid = read_byte()
	language = read_byte() as InSim.Language
	license = read_byte()
	sp2 = read_byte()
	sp3 = read_byte()
	user_id = read_unsigned()
	ip_address.fill_from_int(read_unsigned())


func _get_data_dictionary() -> Dictionary:
	return {
		"UCID": ucid,
		"Language": language,
		"License": license,
		"Sp2": sp2,
		"Sp3": sp3,
		"UserID": user_id,
		"IPAddress": ip_address.address_string,
	}


func _get_pretty_text() -> String:
	return "UCID %d: ID=%s, license=%s, lang=%s, IP=%s" % [
		ucid,
		user_id,
		"demo" if license == 0 else "S%d" % [license],
		(InSim.Language.keys()[language] as String).trim_prefix("LFS_").capitalize(),
		ip_address.address_string
	]
