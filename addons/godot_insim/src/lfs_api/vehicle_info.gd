class_name VehicleInfo
extends RefCounted


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
}
enum ICELayout {
	INLINE,
	FLAT,
	V,
}
enum Drive {
	NONE,
	RWD,
	FWD,
	AWD,
}
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

var id := ""
var name := ""
var description_short := ""
var description := ""
var user_id := 0
var user_name := ""
var wip := false
var published_at := 0  # Unix timestamp
var num_downloads := 0
var current_usage := 0
var rating := 0.0
var num_ratings := 0
var staff_pick := false
var tweak_mod := false
var version := 0
var last_downloaded_at := 0  # Unix timestamp
var vehicle_class := VehicleClass.OBJECT
var electric := false
var cover_url := ""
var screenshot_urls: Array[String] = []
var collaborators := ""

var ice_cc := 0
var ice_num_cylinders := 0
var ice_layout := ICELayout.INLINE
var red_line := 0.0
var drive := Drive.NONE
var shift_type := ShiftType.NONE
var power := 0.0  # power in kW
var max_power_rpm := 0
var torque := 0.0  # torque in N.m
var max_torque_rpm := 0
var mass := 0.0  # total mass in kg
var bhp := 0.0
var power_weight_ratio := 0.0
var bhp_ton := 0.0
var fuel_tank_size := 0.0  # liters for ICE, kWh for electric


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
