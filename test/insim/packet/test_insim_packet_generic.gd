class_name TestInSimPacketGeneric
extends GdUnitTestSuite

func _test_receivable_sendable(packet: InSimPacket) -> void:
	if packet.receivable:
		var _test := assert_bool(has_method("test_decode_packet")) \
				.override_failure_message("Receivable packet is missing test_decode_packet()") \
				.is_true()
	else:
		var _test := assert_bool(has_method("test_decode_packet")) \
				.override_failure_message(
				"Non-receivable packet should not have test_decode_packet()") \
				.is_false()
	if packet.sendable:
		var _test := assert_bool(has_method("test_encode_packet")) \
				.override_failure_message("Sendable packet is missing test_encode_packet()") \
				.is_true()
	else:
		var _test := assert_bool(has_method("test_encode_packet")) \
				.override_failure_message(
				"Non-sendable packet should not have test_encode_packet()") \
				.is_false()
