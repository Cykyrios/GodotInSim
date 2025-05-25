class_name CarSwitches
extends RefCounted
## Helper struct for car switches
##
## This struct can be used to help set switches from the [enum InSim.LocalCarSwitches] enum.

## @deprecated: Signals should be set using [CarLights].
## Signals bit shift
const SIGNALS_BIT_SHIFT := 8
## @deprecated: Signals should be set using [CarLights].
## Signals bit mask
const SIGNALS_BIT_MASK := 0x0300
const FLASH_BIT_SHIFT := 10  ## Flash bit shift
const FLASH_BIT_MASK := 0x0400  ## Flash bit mask
## @deprecated: Headlights should be set using [CarLights].
## Headlights bit shift
const HEADLIGHTS_BIT_SHIFT := 11
## @deprecated: Headlights should be set using [CarLights].
## Headlights bit mask
const HEADLIGHTS_BIT_MASK := 0x0800
const HORN_BIT_SHIFT := 16  ## Horn bit shift
const HORN_BIT_MASK := 0x07_0000  ## Horn bit mask
const SIREN_BIT_SHIFT := 20  ## Siren bit shift
const SIREN_BIT_MASK := 0x30_0000  ## Siren bit mask

## See [enum InSim.LocalCarSwitches].
const MASK_ALL := (
	InSim.LocalCarSwitches.LCS_SET_SIGNALS |
	InSim.LocalCarSwitches.LCS_SET_FLASH |
	InSim.LocalCarSwitches.LCS_SET_HEADLIGHTS |
	InSim.LocalCarSwitches.LCS_SET_HORN |
	InSim.LocalCarSwitches.LCS_SET_SIREN
)

## @deprecated: Signals should be set using [CarLights].
## Whether the signals should be set.
var set_signals := false
var set_flash := false  ## Whether flashing should be set
## @deprecated: Lights should be set using [CarLights].
## Whether the headlights should be set.
var set_headlights := false
var set_horn := false  ## Whether the horn should be set
var set_siren := false  ## Whether the siren should be set

## The value to assign to the signals
var signals := 0:
	set(value):
		signals = clampi(value, 0, 3)
## The value to assign to flashing
var flash := 0:
	set(value):
		flash = clampi(value, 0, 1)
## The value to assign to the headlights
var headlights := 0:
	set(value):
		headlights = clampi(value, 0, 1)
## The value to assign to the horn
var horn := 0:
	set(value):
		horn = clampi(value, 0, 5)
## The value to assign to the siren
var siren := 0:
	set(value):
		siren = clampi(value, 0, 2)


## Creates and returns a new [CarSwitches] object from the given parameters.
static func create(
	lcs_mask := MASK_ALL, lcs_signals := 0, lcs_flash := 0, lcs_headlights := 0, lcs_horn := 0,
	lcs_siren := 0
) -> CarSwitches:
	var car_switches := CarSwitches.new()
	car_switches.set_signals = lcs_mask & InSim.LocalCarSwitches.LCS_SET_SIGNALS
	car_switches.set_flash = lcs_mask & InSim.LocalCarSwitches.LCS_SET_FLASH
	car_switches.set_headlights = lcs_mask & InSim.LocalCarSwitches.LCS_SET_HEADLIGHTS
	car_switches.set_horn = lcs_mask & InSim.LocalCarSwitches.LCS_SET_HORN
	car_switches.set_siren = lcs_mask & InSim.LocalCarSwitches.LCS_SET_SIREN
	car_switches.signals = lcs_signals
	car_switches.flash = lcs_flash
	car_switches.headlights = lcs_headlights
	car_switches.horn = lcs_horn
	car_switches.siren = lcs_siren
	return car_switches


## Creates and returns a new [CarSwitches] object from the given parameters.
static func create_no_mask(
	lcs_signals := -1, lcs_flash := -1, lcs_headlights := -1, lcs_horn := -1, lcs_siren := -1
) -> CarSwitches:
	var car_switches := CarSwitches.new()
	if lcs_signals != -1:
		car_switches.set_signals = true
		car_switches.signals = lcs_signals
	if lcs_flash != -1:
		car_switches.set_flash = true
		car_switches.flash = lcs_flash
	if lcs_headlights != -1:
		car_switches.set_headlights = true
		car_switches.headlights = lcs_headlights
	if lcs_horn != -1:
		car_switches.set_horn = true
		car_switches.horn = lcs_horn
	if lcs_siren != -1:
		car_switches.set_siren = true
		car_switches.siren = lcs_siren
	return car_switches


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


## Returns the integer value corresponding to the values set.
func get_value() -> int:
	var lcs := 0
	lcs |= InSim.LocalCarSwitches.LCS_SET_SIGNALS if set_signals else 0
	lcs |= InSim.LocalCarSwitches.LCS_SET_FLASH if set_flash else 0
	lcs |= InSim.LocalCarSwitches.LCS_SET_HEADLIGHTS if set_headlights else 0
	lcs |= InSim.LocalCarSwitches.LCS_SET_HORN if set_horn else 0
	lcs |= InSim.LocalCarSwitches.LCS_SET_SIREN if set_siren else 0
	lcs = (lcs & ~SIGNALS_BIT_MASK) | signals << SIGNALS_BIT_SHIFT
	lcs = (lcs & ~FLASH_BIT_MASK) | flash << FLASH_BIT_SHIFT
	lcs = (lcs & ~HEADLIGHTS_BIT_MASK) | headlights << HEADLIGHTS_BIT_SHIFT
	lcs = (lcs & ~HORN_BIT_MASK) | horn << HORN_BIT_SHIFT
	lcs = (lcs & ~SIREN_BIT_MASK) | siren << SIREN_BIT_SHIFT
	return lcs
