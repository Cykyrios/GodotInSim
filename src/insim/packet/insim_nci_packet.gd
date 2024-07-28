class_name InSimNCIPacket
extends InSimPacket

## New Conn Info packet - sent on host only if an admin password has been set

const PACKET_SIZE := 16
const PACKET_TYPE := InSim.Packet.ISP_NCI
var ucid := 0  ## connection's unique id (0 = host)

var language := InSim.Language.LFS_ENGLISH  ## see [enum InSim.Language]
var license := 0  ## 0:demo / 1:S1 ...
var sp2 := 0
var sp3 := 0

var user_id := 0  ## LFS UserID
var ip_address := IPAddress.new()


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	receivable = true


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
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
