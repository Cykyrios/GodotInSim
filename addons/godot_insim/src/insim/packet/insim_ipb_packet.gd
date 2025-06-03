class_name InSimIPBPacket
extends InSimPacket
## IP Bans - variable size
##
## This packet is sent to set IP bans or received in response to a [constant InSim.Tiny.TINY_IPB]
## request.

const IPB_MAX_BANS := 120  ## Maximum IP ban count
const IPB_DATA_SIZE := 4  ## IP ban data size

const PACKET_BASE_SIZE := 8  ## Packet base size
const PACKET_MIN_SIZE := PACKET_BASE_SIZE  ## Minimum packet size
const PACKET_MAX_SIZE := PACKET_BASE_SIZE + IPB_DATA_SIZE * IPB_MAX_BANS  ## Maximum packet size
const PACKET_TYPE := InSim.Packet.ISP_IPB  ## The packet's type, see [enum InSim.Packet].
var numb := 0  ## number of bans in this packet

var sp0 := 0  ## Spare
var sp1 := 0  ## Spare
var sp2 := 0  ## Spare
var sp3 := 0  ## Spare

var ban_ips: Array[IPAddress] = []  ## IP addresses, 0 to [constant IPB_MAX_BANS] ([member numb])


## Creates and returns a new [InSimIPBPacket] from the given parameters.
static func create(ipb_numb: int, ipb_array: Array[IPAddress]) -> InSimIPBPacket:
	var packet := InSimIPBPacket.new()
	packet.numb = ipb_numb
	packet.ban_ips = ipb_array.duplicate()
	packet._trim_packet_size()
	return packet


func _init() -> void:
	size = PACKET_MAX_SIZE
	type = PACKET_TYPE
	receivable = true
	sendable = true


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if (
		packet_size < PACKET_MIN_SIZE
		or packet_size > PACKET_MAX_SIZE
		or packet_size % SIZE_MULTIPLIER != 0
	):
		push_error("%s packet expected size [%d..%d step %d], got %d." % [get_type_string(),
				PACKET_MIN_SIZE, PACKET_MAX_SIZE, SIZE_MULTIPLIER, packet_size])
		return
	super(packet)
	numb = read_byte()
	sp0 = read_byte()
	sp1 = read_byte()
	sp2 = read_byte()
	sp3 = read_byte()
	ban_ips.clear()
	for i in numb:
		var ip_address := IPAddress.new()
		ip_address.fill_from_string("%d.%d.%d.%d" % [read_byte(), read_byte(),
				read_byte(), read_byte()])
		ban_ips.append(ip_address)


func _fill_buffer() -> void:
	super()
	update_req_i()
	numb = mini(numb, mini(ban_ips.size(), IPB_MAX_BANS))
	if ban_ips.size() > numb:
		var _resize := ban_ips.resize(numb)
	add_byte(numb)
	add_byte(sp0)
	add_byte(sp1)
	add_byte(sp2)
	add_byte(sp3)
	resize_buffer(PACKET_BASE_SIZE + numb * IPB_DATA_SIZE)
	for i in numb:
		var ip := ban_ips[i].address_array
		add_byte(ip[0])
		add_byte(ip[1])
		add_byte(ip[2])
		add_byte(ip[3])
	_trim_packet_size()


func _get_data_dictionary() -> Dictionary:
	return {
		"NumB": numb,
		"Sp0": sp0,
		"Sp1": sp1,
		"Sp2": sp2,
		"Sp3": sp3,
		"BanIPs": ban_ips,
	}


func _get_pretty_text() -> String:
	var ips := ""
	for i in ban_ips.size():
		var ip := ban_ips[i]
		ips += ("" if i == 0 else ", ") + ip.to_string()
	return "IP bans: %s" % ["NONE" if numb == 0 else ips]


func _trim_packet_size() -> void:
	size = PACKET_BASE_SIZE + IPB_DATA_SIZE * mini(ban_ips.size(), numb)
	resize_buffer(size)
