extends Control


func _ready() -> void:
	print("Requesting mod list...")
	var mod_list: Array[Dictionary] = await LFSAPI.get_mod_list()
	print("Found %d mods" % [mod_list.size()])
	for skin_id: String in ["DBF12E", "424242"]:
		print("Requesting %s details..." % [skin_id])
		print(await LFSAPI.get_mod_details(skin_id))
