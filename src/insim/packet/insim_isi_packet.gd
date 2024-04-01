class_name InSimISIPacket
extends InSimPacket

## InSim Init - packet to initialise the InSim system
##
## NOTE 1) UDPPort field when you connect using UDP:[br]
## - zero: LFS sends all packets to the port of the incoming packet[br]
## - non-zero: LFS sends all packets to the specified UDPPort[br]
## [br]
## NOTE 2) UDPPort field when you connect using TCP:[br]
## - zero: LFS sends NLP / MCI packets using your TCP connection[br]
## - non-zero: LFS sends NLP / MCI packets to the specified UDPPort[br]
## [br]
## NOTE 3) Flags field (set the relevant bits to turn on the option): see [enum InSim.InitFlag][br]
## [br]
## In most cases you should not set both ISF_NLP and ISF_MCI flags
## because all IS_NLP information is included in the IS_MCI packet.[br]
## [br]
## The ISF_LOCAL flag is important if your program creates buttons.
## It should be set if your program is not a host control system.
## If set, then buttons are created in the local button area, so
## avoiding conflict with the host buttons and allowing the user
## to switch them with SHIFT+B rather than SHIFT+I.[br]
## [br]
## NOTE 4) InSimVer field:[br]
## Provide the INSIM_VERSION that your program was designed for.
## Later LFS versions will try to retain backward compatibility
## if it can be provided, within reason. Not guaranteed.[br]
## [br]
## NOTE 5) Prefix field, if set when initialising InSim on a host:[br]
## Messages typed with this prefix will be sent to your InSim program
## on the host (in IS_MSO) and not displayed on anyone's screen.

const PREFIX_LENGTH := 1
const ADMIN_LENGTH := 16
const NAME_LENGTH := 16

const PACKET_SIZE := 44
const PACKET_TYPE := InSim.Packet.ISP_ISI
const REQ_I := 1  ## If non-zero LFS will send an IS_VER packet
var zero := 0

var udp_port := 0  ## Port for UDP replies from LFS (0 to 65535)
var flags := 0  ## Bit flags for options (see [enum InSim.InitFlag])

var insim_version := InSim.VERSION  ## The INSIM_VERSION used by your program
var prefix := ""  ## Special host message prefix character
var interval := 0  ## Time in ms between NLP or MCI (0 = none)

var admin := ""  ## Admin password (if set in LFS)
var i_name := "Godot InSim"  ## A short name for your program


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	req_i = REQ_I
	sendable = true


func _fill_buffer() -> void:
	super()
	add_byte(zero)
	add_word(udp_port)
	add_word(flags)

	add_byte(insim_version)
	add_string(PREFIX_LENGTH, prefix)
	add_word(interval)

	add_string(ADMIN_LENGTH, admin)
	add_string(NAME_LENGTH, i_name)


func _get_data_dictionary() -> Dictionary:
	return {
		"Zero": zero,
		"UDPPort": udp_port,
		"Flags": flags,
		"InSimVer": insim_version,
		"Prefix": prefix,
		"Interval": interval,
		"Admin": admin,
		"IName": i_name,
	}
