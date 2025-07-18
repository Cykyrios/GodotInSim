extends MarginContainer


@export var credentials_file := "res://addons/godot_insim/secrets/lfs_api.txt"

@onready var label: Label = %Label
@onready var rich_text_label: RichTextLabel = %RichTextLabel


func _ready() -> void:
	LFSAPI.credentials_file = credentials_file
	rich_text_label.add_text("Requesting mod list...\n")
	var mod_list := await LFSAPI.get_mod_list()
	var mod_count := mod_list.size()
	rich_text_label.add_text("Found %d mods" % [mod_count] + "\n")
	var skin_ids: Array[String] = ["DBF12E", "74E320", "424242", "898A50"]
	rich_text_label.add_text("Requesting details for mods %s...\n" % str(skin_ids))
	for skin_id in skin_ids:
		var vehicle_info := await LFSAPI.get_mod_details(skin_id)
		if vehicle_info.id.is_empty():
			rich_text_label.add_text("\n%s - ID not found\n" % [skin_id])
			continue
		rich_text_label.add_text("\n%s - %s (%s):\n" % [
			vehicle_info.id,
			vehicle_info.name,
			LFSText.car_get_short_name(vehicle_info.name),
		])
		var image_texture := await LFSAPI.get_png_from_url(vehicle_info.cover_url)
		var image := image_texture.get_image()
		image.resize(
			roundi(image.get_width() * 100.0 / image.get_height()),
			100,
			Image.INTERPOLATE_LANCZOS
		)
		image_texture = ImageTexture.create_from_image(image)
		rich_text_label.add_image(image_texture)
		rich_text_label.add_text("\n" + vehicle_info.description_short)
		rich_text_label.add_text(
			"\n%d kW electric motor, %d N.m, %d kWh battery\n" % [
				roundi(vehicle_info.power),
				roundi(vehicle_info.torque),
				roundi(vehicle_info.fuel_tank_size),
			] if vehicle_info.electric else (
				"\n%.1fL %s%d, " % [
					vehicle_info.ice_cc / 1000.0,
					(
						str(VehicleInfo.ICELayout.keys()[vehicle_info.ice_layout]).to_lower() + " "
					) if vehicle_info.ice_layout != VehicleInfo.ICELayout.V else "V",
					vehicle_info.ice_num_cylinders,
				] + "%d bhp @ %d RPM, %d N.m @ %d RPM, %d kg\n" % [
					roundi(vehicle_info.bhp),
					roundi(vehicle_info.max_power_rpm),
					roundi(vehicle_info.torque),
					roundi(vehicle_info.max_torque_rpm),
					roundi(vehicle_info.mass),
				]
			)
		)
