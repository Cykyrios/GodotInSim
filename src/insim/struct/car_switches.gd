class_name CarSwitches
extends RefCounted


const SIGNALS_BIT_SHIFT := 8
const SIGNALS_BIT_MASK := 0b11
const FLASH_BIT_SHIFT := 10
const FLASH_BIT_MASK := 0b1
const HEADLIGHTS_BIT_SHIFT := 11
const HEADLIGHTS_BIT_MASK := 0b1
const HORN_BIT_SHIFT := 16
const HORN_BIT_MASK := 0b111
const SIREN_BIT_SHIFT := 20
const SIREN_BIT_MASK := 0b11

const ALL_OFF := (
	InSim.LocalCarSwitches.LCS_SET_SIGNALS |
	InSim.LocalCarSwitches.LCS_SET_FLASH |
	InSim.LocalCarSwitches.LCS_SET_HEADLIGHTS |
	InSim.LocalCarSwitches.LCS_SET_HORN |
	InSim.LocalCarSwitches.LCS_SET_SIREN
)

var set_signals := false
var set_flash := false
var set_headlights := false
var set_horn := false
var set_siren := false

var signals := 0:
	set(value):
		signals = clampi(value, 0, 3)
var flash := 0:
	set(value):
		flash = clampi(value, 0, 1)
var headlights := 0:
	set(value):
		headlights = clampi(value, 0, 1)
var horn := 0:
	set(value):
		horn = clampi(value, 0, 5)
var siren := 0:
	set(value):
		siren = clampi(value, 0, 2)


func _init(lcs_mask := 0) -> void:
	set_signals = lcs_mask & InSim.LocalCarSwitches.LCS_SET_SIGNALS
	set_flash = lcs_mask & InSim.LocalCarSwitches.LCS_SET_FLASH
	set_headlights = lcs_mask & InSim.LocalCarSwitches.LCS_SET_HEADLIGHTS
	set_horn = lcs_mask & InSim.LocalCarSwitches.LCS_SET_HORN
	set_siren = lcs_mask & InSim.LocalCarSwitches.LCS_SET_SIREN


func _to_string() -> String:
	return "Signals:" + "%d" % [signals if set_signals else -1] \
			+ ", Flash:" + "%d" % [flash if set_flash else -1] \
			+ ", Headlights:" + "%d" % [headlights if set_headlights else -1] \
			+ ", Horn:" + "%d" % [horn if set_horn else -1] \
			+ ", Siren:" + "%d" % [siren if set_siren else -1]


func get_value() -> int:
	var lcs := 0
	lcs |= InSim.LocalCarSwitches.LCS_SET_SIGNALS if set_signals else 0
	lcs |= InSim.LocalCarSwitches.LCS_SET_FLASH if set_flash else 0
	lcs |= InSim.LocalCarSwitches.LCS_SET_HEADLIGHTS if set_headlights else 0
	lcs |= InSim.LocalCarSwitches.LCS_SET_HORN if set_horn else 0
	lcs |= InSim.LocalCarSwitches.LCS_SET_SIREN if set_siren else 0
	lcs = (lcs & ~(SIGNALS_BIT_MASK << SIGNALS_BIT_SHIFT)) | signals << SIGNALS_BIT_SHIFT
	lcs = (lcs & ~(FLASH_BIT_MASK << FLASH_BIT_SHIFT)) | flash << FLASH_BIT_SHIFT
	lcs = (lcs & ~(HEADLIGHTS_BIT_MASK << HEADLIGHTS_BIT_SHIFT)) | headlights << HEADLIGHTS_BIT_SHIFT
	lcs = (lcs & ~(HORN_BIT_MASK << HORN_BIT_SHIFT)) | horn << HORN_BIT_SHIFT
	lcs = (lcs & ~(SIREN_BIT_MASK << SIREN_BIT_SHIFT)) | siren << SIREN_BIT_SHIFT
	return lcs
