class_name TestInSimPacketGeneric
extends GdUnitTestSuite


func _test_receivable_sendable(packet: InSimPacket) -> void:
	var _test: GdUnitAssert = null
	if packet.receivable:
		_test = assert_bool(has_method("test_decode_packet")) \
				.override_failure_message("Receivable packet is missing test_decode_packet()") \
				.is_true()
	else:
		_test = assert_bool(has_method("test_decode_packet")) \
				.override_failure_message(
				"Non-receivable packet should not have test_decode_packet()") \
				.is_false()
	if packet.sendable:
		_test = assert_bool(has_method("test_encode_packet")) \
				.override_failure_message("Sendable packet is missing test_encode_packet()") \
				.is_true()
		if packet.get_property_list().any(func(property: Dictionary) -> bool:
			return true if (property["name"] as String).begins_with("gis_") else false
		):
			_test = assert_bool(has_method("test_encode_packet_gis")) \
					.override_failure_message(
					"Sendable packet with gis_* values is missing test_encode_packet_gis()") \
					.is_true()
		else:
			_test = assert_bool(has_method("test_encode_packet_gis")) \
					.override_failure_message(
					"Packet without gis_* values should not have test_encode_packet_gis()") \
					.is_false()
	else:
		_test = assert_bool(
			has_method("test_encode_packet")
			or has_method("test_encode_packet_gis")
		).override_failure_message("Non-sendable packet should not have test_encode_packet()") \
				.is_false()
