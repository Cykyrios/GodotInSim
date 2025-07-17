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
	show_manual_buttons()
	show_auto_buttons()
	show_global_button()
	update_auto_buttons()


func _exit_tree() -> void:
	if insim.is_host():
		insim.send_message("Host InSim closed")


func show_auto_buttons(for_ucid := 255) -> void:
	insim.buttons.id_range = Vector2i(50, 80)
	insim.add_button(
		[for_ucid],
		Vector2i(auto_buttons_left, auto_buttons_top),
		Vector2i(2 * auto_button_width, 9 * auto_button_height),
		InSim.ButtonStyle.ISB_LIGHT,
		"",
		"auto/background",
	)
	insim.add_button(
		[for_ucid],
		Vector2i(auto_buttons_left, auto_buttons_top),
		Vector2i(2 * auto_button_width, roundi(1.5 * auto_button_height)),
		InSim.ButtonColor.ISB_TITLE,
		"Auto Buttons",
		"auto/title",
	)
	insim.add_button(
		[for_ucid],
		Vector2i(auto_buttons_left, auto_buttons_top + 2 * auto_button_height),
		Vector2i(2 * auto_button_width, auto_button_height),
		0,
		"Custom clickID range: %d-%d" % [
			insim.buttons.id_range.x, insim.buttons.id_range.y
		],
		"auto/range",
	)
	insim.add_button(
		[for_ucid],
		Vector2i(auto_buttons_left, auto_buttons_top + 3 * auto_button_height),
		Vector2i(2 * auto_button_width, auto_button_height),
		0,
		"test",
		"auto/test",
	)
	var button := insim.get_button_by_name("auto/test", for_ucid)
	if button:
		button.text = "ID=%d, name=%s" % [button.click_id, button.name]
		insim.send_packet(button.get_btn_packet(true))
	insim.add_button(
		[for_ucid],
		Vector2i(auto_buttons_left + 2, auto_buttons_top + 4 * auto_button_height),
		Vector2i(2 * auto_button_width - 4, auto_button_height),
		InSim.ButtonStyle.ISB_DARK | InSim.ButtonStyle.ISB_CLICK,
		func(ucid: int) -> String: return insim.get_connection_nickname(ucid),
		"auto/player_name",
	)
	insim.add_button(
		[for_ucid],
		Vector2i(auto_buttons_left + 2, auto_buttons_top + 5 * auto_button_height),
		Vector2i(2 * auto_button_width - 4, auto_button_height),
		InSim.ButtonStyle.ISB_DARK | InSim.ButtonStyle.ISB_CLICK,
		"Time",
		"auto/clock",
	)
	insim.add_button(
		[for_ucid],
		Vector2i(auto_buttons_left + 2, auto_buttons_top + 7 * auto_button_height),  # 6 is blink
		Vector2i(2 * auto_button_width - 4, auto_button_height),
		InSim.ButtonStyle.ISB_DARK | InSim.ButtonStyle.ISB_CLICK,
		"Show menu",
		"auto/menu",
	)


func show_global_button() -> void:
	insim.add_global_button(
		Vector2i(50, 1),
		Vector2i(50, 5),
		InSim.ButtonStyle.ISB_DARK | InSim.ButtonStyle.ISB_CLICK,
		"Last clicker: nobody",
		"global/last_clicker",
	)


func show_manual_buttons() -> void:
	insim.send_packet(InSimBTNPacket.create(
		255, 0, 0,
		InSim.ButtonStyle.ISB_LIGHT,
		0,
		manual_buttons_left, manual_buttons_top,
		2 * manual_button_width, 9 * manual_button_height,
	))
	insim.send_packet(InSimBTNPacket.create(
		255, 1, 0,
		InSim.ButtonColor.ISB_TITLE,
		0,
		manual_buttons_left, manual_buttons_top,
		2 * manual_button_width, roundi(1.5 * manual_button_height),
		"Manual Buttons"
	))
	insim.send_packet(InSimBTNPacket.create(
		255, 2, 0,
		InSim.ButtonColor.ISB_LIGHT_GRAY,
		0,
		manual_buttons_left, manual_buttons_top + 2 * manual_button_height,
		manual_button_width, manual_button_height,
		"Default"
	))
	insim.send_packet(InSimBTNPacket.create(
		255, 3, 0,
		InSim.ButtonColor.ISB_TITLE,
		0,
		manual_buttons_left + manual_button_width, manual_buttons_top + 2 * manual_button_height,
		manual_button_width, manual_button_height,
		"Title"
	))
	insim.send_packet(InSimBTNPacket.create(
		255, 4, 0,
		InSim.ButtonColor.ISB_UNSELECTED,
		0,
		manual_buttons_left, manual_buttons_top + 3 * manual_button_height,
		manual_button_width, manual_button_height,
		"Unselected"
	))
	insim.send_packet(InSimBTNPacket.create(
		255, 5, 0,
		InSim.ButtonColor.ISB_SELECTED,
		0,
		manual_buttons_left + manual_button_width, manual_buttons_top + 3 * manual_button_height,
		manual_button_width, manual_button_height,
		"Selected"
	))
	insim.send_packet(InSimBTNPacket.create(
		255, 6, 0,
		InSim.ButtonColor.ISB_OK,
		0,
		manual_buttons_left, manual_buttons_top + 4 * manual_button_height,
		manual_button_width, manual_button_height,
		"OK"
	))
	insim.send_packet(InSimBTNPacket.create(
		255, 7, 0,
		InSim.ButtonColor.ISB_CANCEL,
		0,
		manual_buttons_left + manual_button_width, manual_buttons_top + 4 * manual_button_height,
		manual_button_width, manual_button_height,
		"Cancel"
	))
	insim.send_packet(InSimBTNPacket.create(
		255, 8, 0,
		InSim.ButtonColor.ISB_TEXT,
		0,
		manual_buttons_left, manual_buttons_top + 5 * manual_button_height,
		manual_button_width, manual_button_height,
		"Text String"
	))
	insim.send_packet(InSimBTNPacket.create(
		255, 9, 0,
		InSim.ButtonColor.ISB_UNAVAILABLE,
		0,
		manual_buttons_left + manual_button_width, manual_buttons_top + 5 * manual_button_height,
		manual_button_width, manual_button_height,
		"Unavailable"
	))
	insim.send_packet(InSimBTNPacket.create(
		255, 10, 0,
		InSim.ButtonStyle.ISB_DARK | InSim.ButtonStyle.ISB_CLICK | InSim.ButtonColor.ISB_OK,
		0,
		manual_buttons_left + roundi(0.5 * manual_button_width), manual_buttons_top + roundi(6.5 * manual_button_height),
		manual_button_width, manual_button_height,
		"Click"
	))
	insim.send_packet(InSimBTNPacket.create(
		255, 11, 0,
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
		insim.delete_buttons_by_prefix([for_ucid], "menu/")
		insim.update_button_text(insim.get_button_by_name("auto/menu", for_ucid), "Show menu")
		return
	menu_open.append(for_ucid)
	insim.update_button_text(insim.get_button_by_name("auto/menu", for_ucid), "Close menu")
	insim.add_button(
		[for_ucid],
		Vector2i(menu_buttons_left, menu_buttons_top),
		Vector2i(2 * menu_button_width, 5 * menu_button_height),
		InSim.ButtonStyle.ISB_LIGHT,
		"",
		"menu/background",
	)
	insim.add_button(
		[for_ucid],
		Vector2i(menu_buttons_left + 2, menu_buttons_top),
		Vector2i(2 * menu_button_width - 4, 2 * menu_button_height),
		InSim.ButtonColor.ISB_TITLE,
		"Menu",
		"menu/title",
	)
	insim.add_button(
		[for_ucid],
		Vector2i(menu_buttons_left + 2 * menu_button_width - 4, menu_buttons_top),
		Vector2i(4, menu_button_height),
		InSim.ButtonStyle.ISB_DARK | InSim.ButtonStyle.ISB_CLICK,
		LFSText.get_color_code(LFSText.ColorCode.RED) + "X",
		"menu/close",
	)
	insim.add_button(
		[for_ucid],
		Vector2i(menu_buttons_left + 2, menu_buttons_top + 2 * menu_button_height),
		Vector2i(2 * menu_button_width - 4, menu_button_height),
		InSim.ButtonStyle.ISB_DARK | InSim.ButtonStyle.ISB_CLICK,
		"Item 1",
		"menu/item_1",
	)
	insim.add_button(
		[for_ucid],
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
		var buttons := insim.get_global_button_by_name("auto/clock")
		if not buttons.is_empty():
			insim.update_global_button_text(
				buttons[0].click_id,
				Time.get_time_string_from_system(true),
			)
		loop += 1
		if loop % 2:
			insim.add_button(
				[],
				Vector2i(auto_buttons_left + 2, auto_buttons_top + 6 * auto_button_height),
				Vector2i(2 * auto_button_width - 4, auto_button_height),
				0,
				"",
				"auto/blink",
			)
			var click_id := insim.buttons.get_global_button_id_from_name("auto/blink")
			if click_id != -1:
				insim.update_global_button_text(click_id, "ID=%d, name=%s" % [
					click_id, "auto/blink"
				])
		else:
			insim.delete_global_button_by_name("auto/blink")


func update_last_clicker_button(clicker_ucid: int) -> void:
	var button_array := insim.get_global_button_by_name("global/last_clicker")
	var button_id := button_array[0].click_id if not button_array.is_empty() else -1
	if button_id < 0:
		return
	insim.update_global_button_text(
		button_id,
		"Last clicker: %s" % [insim.get_connection_nickname(clicker_ucid)]
	)


func update_player_name_button(ucid: int) -> void:
	var button := insim.get_button_by_name("auto/player_name", ucid)
	if button and button.name == "auto/player_name":
		button.text = "ID=%d, name=%s" % [
			button.click_id,
			button.name,
		] if button.text == insim.get_connection_nickname(button.ucid) \
				else insim.get_connection_nickname(button.ucid)
		insim.send_packet(button.get_btn_packet(true))


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
	# Note that buttons created manually are not tracked in InSimButtons; you can either
	# add them manually (insim.buttons[ucid] = InSimButtonDictionary.new(), then
	# add a manually created InSimButton to it), or keep track of manual buttons yourself.
	# For click_id == 10 below, we check packet.click_id instead of button.click_id for
	# that reason.
	var button := insim.get_button_by_id(packet.click_id, packet.ucid)
	var flags := packet.click_flags
	var message := "You clicked %s (%s)." % [
		"the ^2Click^8 button in the Manual Buttons category" if packet.click_id == 10 \
				else "the player name button" if button and button.name == "auto/player_name" \
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
		"\"%s\"" % [packet.text + LFSText.get_color_code(LFSText.ColorCode.DEFAULT)] \
				if not packet.text.is_empty() else "nothing",
		"the ^6Type^8 button in the Manual Button category" if packet.click_id == 11 \
				else "a button",
	]
	if insim.lfs_state.flags & InSim.State.ISS_MULTI:
		insim.send_message_to_connection(
			255,
			message.replace("You", insim.get_connection_nickname(packet.ucid) \
					+ LFSText.get_color_code(LFSText.ColorCode.DEFAULT)),
			InSim.MessageSound.SND_MESSAGE
		)
	else:
		insim.send_local_message(message, InSim.MessageSound.SND_MESSAGE)


func _on_global_buttons_restored(ucid: int) -> void:
	update_player_name_button(ucid)
	# We could connect to isp_ncn_received and check the req_i instead, but this works too.
	show_manual_buttons()
