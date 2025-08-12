extends Control


@export var insim_ip := "127.0.0.1"
@export var insim_port := 29_999

var insim: InSim = null

var auto_buttons_left := 50
var auto_buttons_top := 40
var auto_button_width := 15
var auto_button_height := 5
var manual_buttons_left := 10
var manual_buttons_top := 40
var manual_button_width := 15
var manual_button_height := 5
var menu_buttons_left := 80
var menu_buttons_top := 40
var menu_button_width := 10
var menu_button_height := 5

var menu_open: Array[int] = []  # List of UCIDs that have the menu open.


func _ready() -> void:
	insim = InSim.new()
	add_child(insim)
	# You can connect to InSim.connection_cleared_buttons and InSim.connection_requested_buttons
	# instead of InSim.isp_bfn_received and differentiating the subtype.
	var _connect := insim.isp_bfn_received.connect(_on_bfn_received)
	_connect = insim.isp_btc_received.connect(_on_btc_received)
	_connect = insim.isp_btt_received.connect(_on_btt_received)
	_connect = insim.global_buttons_restored.connect(_on_global_buttons_restored)
	insim.initialize(
		insim_ip,
		insim_port,
		InSimInitializationData.create(
			"InSim Buttons",
			InSim.InitFlag.ISF_MSO_COLS,
		)
	)
	await insim.connected
	if insim.is_host():
		insim.send_message("Host InSim started")
	insim.button_manager.id_range = Vector2i(50, 80)
	show_manual_buttons()
	show_global_button()
	show_auto_buttons()
	update_auto_buttons()


func _exit_tree() -> void:
	if insim.is_host():
		insim.send_message("Host InSim closed")


func show_auto_buttons(for_ucid := -1) -> void:
	var ucid_array: Array[int] = []
	if for_ucid > -1:
		ucid_array.append(for_ucid)
	insim.add_multi_button(
		ucid_array,
		Vector2i(auto_buttons_left, auto_buttons_top),
		Vector2i(2 * auto_button_width, 9 * auto_button_height),
		InSim.ButtonStyle.ISB_LIGHT,
		"",
		"auto/background",
	)
	insim.add_multi_button(
		ucid_array,
		Vector2i(auto_buttons_left, auto_buttons_top),
		Vector2i(2 * auto_button_width, roundi(1.5 * auto_button_height)),
		InSim.ButtonColor.ISB_TITLE,
		"Auto Buttons",
		"auto/title",
	)
	insim.add_multi_button(
		ucid_array,
		Vector2i(auto_buttons_left, auto_buttons_top + 2 * auto_button_height),
		Vector2i(2 * auto_button_width, auto_button_height),
		0,
		"Custom clickID range: %d-%d" % [
			insim.button_manager.id_range.x, insim.button_manager.id_range.y
		],
		"auto/range",
	)
	insim.add_multi_button(
		ucid_array,
		Vector2i(auto_buttons_left, auto_buttons_top + 3 * auto_button_height),
		Vector2i(2 * auto_button_width, auto_button_height),
		0,
		"test",
		"auto/test",
	)
	var button := insim.get_button_by_name(
		insim.connections.keys()[0] as int, "auto/test"
	) as InSimMultiButton
	if button:
		var test_callable := func(ucid: int) -> String:
			var mapping := button.get_ucid_mapping(ucid)
			var click_id_string := str(mapping.click_id) if mapping else "###"
			return "ID=%s, name=%s" % [click_id_string, button.name]
		insim.update_multi_button(button, test_callable)
	insim.add_multi_button(
		ucid_array,
		Vector2i(auto_buttons_left + 2, auto_buttons_top + 4 * auto_button_height),
		Vector2i(2 * auto_button_width - 4, auto_button_height),
		InSim.ButtonStyle.ISB_DARK | InSim.ButtonStyle.ISB_CLICK,
		func(ucid: int) -> String: return insim.get_connection_nickname(ucid),
		"auto/player_name",
	)
	insim.add_multi_button(
		ucid_array,
		Vector2i(auto_buttons_left + 2, auto_buttons_top + 5 * auto_button_height),
		Vector2i(2 * auto_button_width - 4, auto_button_height),
		InSim.ButtonStyle.ISB_DARK | InSim.ButtonStyle.ISB_CLICK,
		"Time",
		"auto/clock",
	)
	insim.add_multi_button(
		ucid_array,
		Vector2i(auto_buttons_left + 2, auto_buttons_top + 7 * auto_button_height),  # 6 is blink
		Vector2i(2 * auto_button_width - 4, auto_button_height),
		InSim.ButtonStyle.ISB_DARK | InSim.ButtonStyle.ISB_CLICK,
		"Show menu",
		"auto/menu",
	)


func show_global_button() -> void:
	insim.add_solo_button(
		InSim.UCID_ALL,
		Vector2i(50, 1),
		Vector2i(50, 5),
		InSim.ButtonStyle.ISB_DARK | InSim.ButtonStyle.ISB_CLICK,
		"Last clicker: nobody",
		"global/last_clicker",
	)


func show_manual_buttons() -> void:
	insim.send_packet(InSimBTNPacket.create(
		InSim.UCID_ALL, 0, 0,
		InSim.ButtonStyle.ISB_LIGHT,
		0,
		manual_buttons_left, manual_buttons_top,
		2 * manual_button_width, 9 * manual_button_height,
	))
	insim.send_packet(InSimBTNPacket.create(
		InSim.UCID_ALL, 1, 0,
		InSim.ButtonColor.ISB_TITLE,
		0,
		manual_buttons_left, manual_buttons_top,
		2 * manual_button_width, roundi(1.5 * manual_button_height),
		"Manual Buttons"
	))
	insim.send_packet(InSimBTNPacket.create(
		InSim.UCID_ALL, 2, 0,
		InSim.ButtonColor.ISB_LIGHT_GRAY,
		0,
		manual_buttons_left, manual_buttons_top + 2 * manual_button_height,
		manual_button_width, manual_button_height,
		"Default"
	))
	insim.send_packet(InSimBTNPacket.create(
		InSim.UCID_ALL, 3, 0,
		InSim.ButtonColor.ISB_TITLE,
		0,
		manual_buttons_left + manual_button_width, manual_buttons_top + 2 * manual_button_height,
		manual_button_width, manual_button_height,
		"Title"
	))
	insim.send_packet(InSimBTNPacket.create(
		InSim.UCID_ALL, 4, 0,
		InSim.ButtonColor.ISB_UNSELECTED,
		0,
		manual_buttons_left, manual_buttons_top + 3 * manual_button_height,
		manual_button_width, manual_button_height,
		"Unselected"
	))
	insim.send_packet(InSimBTNPacket.create(
		InSim.UCID_ALL, 5, 0,
		InSim.ButtonColor.ISB_SELECTED,
		0,
		manual_buttons_left + manual_button_width, manual_buttons_top + 3 * manual_button_height,
		manual_button_width, manual_button_height,
		"Selected"
	))
	insim.send_packet(InSimBTNPacket.create(
		InSim.UCID_ALL, 6, 0,
		InSim.ButtonColor.ISB_OK,
		0,
		manual_buttons_left, manual_buttons_top + 4 * manual_button_height,
		manual_button_width, manual_button_height,
		"OK"
	))
	insim.send_packet(InSimBTNPacket.create(
		InSim.UCID_ALL, 7, 0,
		InSim.ButtonColor.ISB_CANCEL,
		0,
		manual_buttons_left + manual_button_width, manual_buttons_top + 4 * manual_button_height,
		manual_button_width, manual_button_height,
		"Cancel"
	))
	insim.send_packet(InSimBTNPacket.create(
		InSim.UCID_ALL, 8, 0,
		InSim.ButtonColor.ISB_TEXT,
		0,
		manual_buttons_left, manual_buttons_top + 5 * manual_button_height,
		manual_button_width, manual_button_height,
		"Text String"
	))
	insim.send_packet(InSimBTNPacket.create(
		InSim.UCID_ALL, 9, 0,
		InSim.ButtonColor.ISB_UNAVAILABLE,
		0,
		manual_buttons_left + manual_button_width, manual_buttons_top + 5 * manual_button_height,
		manual_button_width, manual_button_height,
		"Unavailable"
	))
	insim.send_packet(InSimBTNPacket.create(
		InSim.UCID_ALL, 10, 0,
		InSim.ButtonStyle.ISB_DARK | InSim.ButtonStyle.ISB_CLICK | InSim.ButtonColor.ISB_OK,
		0,
		manual_buttons_left + roundi(0.5 * manual_button_width), manual_buttons_top + roundi(6.5 * manual_button_height),
		manual_button_width, manual_button_height,
		"Click"
	))
	insim.send_packet(InSimBTNPacket.create(
		InSim.UCID_ALL, 11, 0,
		InSim.ButtonStyle.ISB_DARK | InSim.ButtonStyle.ISB_CLICK | InSim.ButtonColor.ISB_TEXT,
		10,
		manual_buttons_left + roundi(0.5 * manual_button_width), manual_buttons_top + roundi(7.5 * manual_button_height),
		manual_button_width, manual_button_height,
		"Type",
		"You can type up to 10 characters"
	))


func toggle_menu(for_ucid: int) -> void:
	if menu_open.has(for_ucid):
		menu_open.erase(for_ucid)
		insim.delete_buttons(insim.get_buttons_by_prefix(for_ucid, "menu/"))
		insim.update_multi_button(
			insim.get_button_by_name(for_ucid, "auto/menu") as InSimMultiButton,
			"Show menu",
		)
		return
	menu_open.append(for_ucid)
	insim.update_multi_button(
		insim.get_button_by_name(for_ucid, "auto/menu") as InSimMultiButton,
		"Close menu",
	)
	insim.add_solo_button(
		for_ucid,
		Vector2i(menu_buttons_left, menu_buttons_top),
		Vector2i(2 * menu_button_width, 5 * menu_button_height),
		InSim.ButtonStyle.ISB_LIGHT,
		"",
		"menu/background",
	)
	insim.add_solo_button(
		for_ucid,
		Vector2i(menu_buttons_left + 2, menu_buttons_top),
		Vector2i(2 * menu_button_width - 4, 2 * menu_button_height),
		InSim.ButtonColor.ISB_TITLE,
		"Menu",
		"menu/title",
	)
	insim.add_solo_button(
		for_ucid,
		Vector2i(menu_buttons_left + 2 * menu_button_width - 4, menu_buttons_top),
		Vector2i(4, menu_button_height),
		InSim.ButtonStyle.ISB_DARK | InSim.ButtonStyle.ISB_CLICK,
		LFSText.get_color_code(LFSText.ColorCode.RED) + "X",
		"menu/close",
	)
	insim.add_solo_button(
		for_ucid,
		Vector2i(menu_buttons_left + 2, menu_buttons_top + 2 * menu_button_height),
		Vector2i(2 * menu_button_width - 4, menu_button_height),
		InSim.ButtonStyle.ISB_DARK | InSim.ButtonStyle.ISB_CLICK,
		"Item 1",
		"menu/item_1",
	)
	insim.add_solo_button(
		for_ucid,
		Vector2i(menu_buttons_left + 2, menu_buttons_top + 3 * menu_button_height),
		Vector2i(2 * menu_button_width - 4, menu_button_height),
		InSim.ButtonStyle.ISB_DARK | InSim.ButtonStyle.ISB_CLICK,
		"Item 2",
		"menu/item_2",
	)


func update_auto_buttons() -> void:
	# Infinite loop to get updates every second, obviously not a good choice if you want
	# to be able to interrupt the loop cleanly. However, global buttons allow disabling InSim
	# buttons cleanly with Shift+I, so you won't receive "stray buttons" when disabled.
	var loop := 0
	while true:
		await get_tree().create_timer(1).timeout
		var button := insim.get_button_by_name(0, "auto/clock") as InSimMultiButton
		if button:
			insim.update_multi_button(
				button,
				Time.get_time_string_from_system(),
			)
		loop += 1
		if loop % 2:
			insim.add_multi_button(
				[],
				Vector2i(auto_buttons_left + 2, auto_buttons_top + 6 * auto_button_height),
				Vector2i(2 * auto_button_width - 4, auto_button_height),
				0,
				"",
				"auto/blink",
			)
			button = insim.get_button_by_name(0, "auto/blink")
			if button:
				var get_click_id := func(ucid: int) -> String:
					var mapping := button.get_ucid_mapping(ucid)
					var click_id_string := str(mapping.click_id) if mapping else "###"
					return "ID=%s, name=%s" % [click_id_string, "auto/blink"]
				insim.update_multi_button(button, get_click_id)
		else:
			insim.delete_button(insim.get_button_by_name(0, "auto/blink"))


func update_last_clicker_button(clicker_ucid: int) -> void:
	var button := insim.get_button_by_name(InSim.UCID_ALL, "global/last_clicker") as InSimSoloButton
	if not button:
		return
	insim.update_solo_button(
		button,
		"Last clicker: %s" % [insim.get_connection_nickname(clicker_ucid)]
	)


func update_player_name_button(ucid: int) -> void:
	var button := insim.get_button_by_name(ucid, "auto/player_name") as InSimMultiButton
	if button and button.name == "auto/player_name":
		var get_text := func(for_ucid: int) -> String:
			var mapping := button.get_ucid_mapping(for_ucid)
			return (
				"ID=%d, name=%s" % [
					mapping.click_id,
					button.name,
				] if mapping.text == insim.get_connection_nickname(for_ucid)
				else insim.get_connection_nickname(for_ucid)
			)
		insim.update_multi_button(button, get_text)


func _on_bfn_received(packet: InSimBFNPacket) -> void:
	# You can connect to InSim.connection_cleared_buttons instead
	if packet.subtype == InSim.ButtonFunction.BFN_USER_CLEAR:
		var message := "%s cleared the InSim buttons." % [
			"You" if packet.ucid == 0 else (insim.connections[packet.ucid].nickname + "^9")
		]
		if insim.lfs_state.flags & InSim.State.ISS_MULTI:
			insim.send_message_to_connection(packet.ucid, message)
		else:
			insim.send_local_message(message)
	# You can connect to InSim.connection_requested_buttons instead
	elif packet.subtype == InSim.ButtonFunction.BFN_REQUEST:
		var message := "%s requested InSim buttons." % [
			"You" if packet.ucid == 0 else (insim.connections[packet.ucid].nickname + "^9")
		]
		if insim.lfs_state.flags & InSim.State.ISS_MULTI:
			insim.send_message_to_connection(packet.ucid, message)
		else:
			insim.send_local_message(message)
		# Here we show manual buttons again, as they are not tracked by the button manager.
		# Auto buttons are restored automatically, and so is the menu if it was open.
		show_manual_buttons()


func _on_btc_received(packet: InSimBTCPacket) -> void:
	# Note that buttons created manually are not tracked by [InSimButtonManager]; you can
	# either add them manually (insim.button_manager[ucid] = InSimButtonDictionary.new(),
	# then add a manually created InSimButton to it), or keep track of manual buttons
	# yourself. For click_id == 10 below, we check packet.click_id instead of button.click_id
	# for that reason.
	var button := insim.get_button_by_id(packet.ucid, packet.click_id)
	if not button:
		button = insim.get_button_by_id(InSim.UCID_ALL, packet.click_id)
	var flags := packet.click_flags
	var message := "You clicked %s (%s)." % [
		"the ^2Click^8 button in the Manual Buttons category" if packet.click_id == 10
		else "the player name button" if button and button.name == "auto/player_name"
		else "a button",
		"%s click%s%s" % [
			"right" if flags & InSim.ButtonClick.ISB_RMB else "left",
			" + Ctrl" if flags & InSim.ButtonClick.ISB_CTRL else "",
			" + Shift" if flags & InSim.ButtonClick.ISB_SHIFT else "",
		],
	]
	insim.send_message_to_connection(packet.ucid, message, InSim.MessageSound.SND_SYSMESSAGE)
	if not button:
		return
	match button.name:
		"auto/menu":
			toggle_menu(packet.ucid)
		"auto/player_name":
			update_player_name_button(packet.ucid)
		"global/last_clicker":
			update_last_clicker_button(packet.ucid)
		"menu/close":
			toggle_menu(packet.ucid)


func _on_btt_received(packet: InSimBTTPacket) -> void:
	var message := "You typed %s in %s." % [
		"\"%s\"" % [
			packet.text + LFSText.get_color_code(LFSText.ColorCode.DEFAULT)
		] if not packet.text.is_empty() else "nothing",
		"the ^6Type^8 button in the Manual Button category" if packet.click_id == 11
		else "a button",
	]
	if insim.lfs_state.flags & InSim.State.ISS_MULTI:
		insim.send_message_to_connection(
			InSim.UCID_ALL,
			message.replace(
				"You",
				insim.get_connection_nickname(packet.ucid)
				+ LFSText.get_color_code(LFSText.ColorCode.DEFAULT),
			),
			InSim.MessageSound.SND_MESSAGE
		)
	else:
		insim.send_local_message(message, InSim.MessageSound.SND_MESSAGE)


func _on_global_buttons_restored(ucid: int) -> void:
	update_player_name_button(ucid)
	# We could connect to isp_ncn_received and check the req_i instead, but this works too.
	show_manual_buttons()
