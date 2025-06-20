class_name VehicleInfo
extends RefCounted
## Mod vehicle info
##
## This class contains data fetched from the LFS REST API.

## Mod vehicle classes
enum VehicleClass {
	OBJECT,
	TOURING_CAR,
	SALOON_CAR,
	BUGGY,
	FORMULA,
	GT,
	KART,
	BIKE,
	VAN,
	TRUCK,
	FORMULA_1,
	FORMULA_SAE,
	BUS,
	PROTOTYPE,
}
## Internal combustion engine layouts
enum ICELayout {
	INLINE,
	FLAT,
	V,
}
## Drive types
enum Drive {
	NONE,
	RWD,
	FWD,
	AWD,
}
## Gearbox types
enum ShiftType {
	NONE,
	H_PATTERN_GEARBOX,
	MOTORBIKE,
	SEQUENTIAL,
	SEQUENTIAL_WITH_IGNITION_CUT,
	PADDLE,
	ELECTRIC_MOTOR,
	CENTRIFUGAL_CLUTCH,
}

var id := ""  ## The mod's skin ID
var name := ""  ## The mod's full name
var description_short := ""  ## The mod's short description
var description := ""  ## The mod's full description
var user_id := 0  ## User ID of the mod uploader
var user_name := ""  ## User name of the mod uploader
var wip := false  ## Work in progress status of the mod
var published_at := 0  ## Unix timestamp of the mod publication date
var num_downloads := 0  ## Number of downloads
var current_usage := 0  ## Number of people online using this mod
var rating := 0.0  ## Mod rating
var num_ratings := 0  ## Number of ratings
var staff_pick := false  ## Whether the mod is a staff pick
var tweak_mod := false  ## Whether the mod is a tweak from another mod
var version := 0  ## The mod's version
var last_downloaded_at := 0  ## Unix timestamp of the latest download
var vehicle_class := VehicleClass.OBJECT  ## Mod vehicle class
var electric := false  ## Whether this is an electric vehicle
var cover_url := ""  ## The URL of the mod's cover picture
var screenshot_urls: Array[String] = []  ## The URLs of the mod's screenshots
var collaborators := ""  ## The list of collaborators for this mod

var ice_cc := 0  ## Piston displacement in cubic centimeters
var ice_num_cylinders := 0  ## Number of cylinders
var ice_layout := ICELayout.INLINE  ## Engine layout
var red_line := 0.0  ## Red line RPM
var drive := Drive.NONE  ## Drive type
var shift_type := ShiftType.NONE  ## Gearbox type
var power := 0.0  ## Power in kW
var max_power_rpm := 0  ## Max power RPM
var torque := 0.0  ## Torque in N.m
var max_torque_rpm := 0  ## Max torque RPM
var mass := 0.0  ## Total mass in kg, without driver or fuel
var bhp := 0.0  ## Horsepower
var power_weight_ratio := 0.0  ## Power to weight ratio
var bhp_ton := 0.0  ## Horsepower per ton ratio
var fuel_tank_size := 0.0  ## Fuel tank size in liters for ICE, battery size in kWh for electric


## Creates and returns a new [VehicleInfo] object from the given [param dict] obtained from a
## REST API request.
static func create_from_dictionary(dict: Dictionary) -> VehicleInfo:
	var get_dict_value := func get_dict_value(
		dictionary: Dictionary, key: String, default_value: Variant
	) -> Variant:
		if dictionary.has(key):
			return dictionary[key]
		return default_value
	var vehicle_info := VehicleInfo.new()
	vehicle_info.id = get_dict_value.call(dict, "id", "") as String
	vehicle_info.name = get_dict_value.call(dict, "name", "") as String
	vehicle_info.description_short = get_dict_value.call(dict, "descriptionShort", "") as String
	vehicle_info.description = get_dict_value.call(dict, "description", "") as String
	vehicle_info.user_id = get_dict_value.call(dict, "userId", 0) as int
	vehicle_info.user_name = get_dict_value.call(dict, "userName", "") as String
	vehicle_info.wip = get_dict_value.call(dict, "wip", false) as bool
	vehicle_info.published_at = get_dict_value.call(dict, "publishedAt", 0) as int
	vehicle_info.num_downloads = get_dict_value.call(dict, "numDownloads", 0) as int
	vehicle_info.current_usage = get_dict_value.call(dict, "curUsage", 0) as int
	vehicle_info.rating = get_dict_value.call(dict, "rating", 0.0) as float
	vehicle_info.num_ratings = get_dict_value.call(dict, "numRatings", 0) as int
	vehicle_info.staff_pick = get_dict_value.call(dict, "staffPick", false) as bool
	vehicle_info.tweak_mod = get_dict_value.call(dict, "tweakMod", false) as bool
	vehicle_info.version = get_dict_value.call(dict, "version", 0) as int
	vehicle_info.last_downloaded_at = get_dict_value.call(dict, "lastDownloadedAt", 0) as int
	vehicle_info.vehicle_class = get_dict_value.call(
			dict, "class", VehicleClass.OBJECT) as VehicleClass
	vehicle_info.electric = get_dict_value.call(dict, "ev", false) as bool
	vehicle_info.cover_url = get_dict_value.call(dict, "coverUrl", "") as String
	vehicle_info.screenshot_urls.assign(
			get_dict_value.call(dict, "screenshotUrls", []) as Array[String])
	vehicle_info.collaborators = get_dict_value.call(dict, "collaborators", "") as String
	var vehicle_details := get_dict_value.call(dict, "vehicle", {}) as Dictionary
	if vehicle_details:
		vehicle_info.ice_cc = get_dict_value.call(vehicle_details, "iceCc", 0) as int
		vehicle_info.ice_num_cylinders = get_dict_value.call(
				vehicle_details, "iceNumCylinders", 0) as int
		vehicle_info.ice_layout = get_dict_value.call(
				vehicle_details, "iceLayout", ICELayout.INLINE) as ICELayout
		vehicle_info.red_line = get_dict_value.call(vehicle_details, "evRedLine", 0.0) as float
		vehicle_info.drive = get_dict_value.call(vehicle_details, "drive", Drive.NONE) as Drive
		vehicle_info.shift_type = get_dict_value.call(
				vehicle_details, "shiftType", ShiftType.NONE) as ShiftType
		vehicle_info.power = get_dict_value.call(vehicle_details, "power", 0.0) as float
		vehicle_info.max_power_rpm = get_dict_value.call(vehicle_details, "maxPowerRpm", 0) as int
		vehicle_info.torque = get_dict_value.call(vehicle_details, "torque", 0.0) as float
		vehicle_info.max_torque_rpm = get_dict_value.call(vehicle_details, "maxTorqueRpm", 0) as int
		vehicle_info.mass = get_dict_value.call(vehicle_details, "mass", 0.0) as float
		vehicle_info.bhp = get_dict_value.call(vehicle_details, "bhp", 0.0) as float
		vehicle_info.power_weight_ratio = get_dict_value.call(
				vehicle_details, "powerWeightRatio", 0.0) as float
		vehicle_info.bhp_ton = get_dict_value.call(vehicle_details, "bhpTon", 0.0) as float
		vehicle_info.fuel_tank_size = get_dict_value.call(
				vehicle_details, "fuelTankSize", 0.0) as float
	return vehicle_info
