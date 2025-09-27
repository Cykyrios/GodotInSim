extends GdUnitTestSuite

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/insim.gd"

var tcp_server: TCPServer = null
var insim: InSim = null


func before_test() -> void:
	tcp_server = auto_free(TCPServer.new())
	var _error := tcp_server.listen(29_999, "127.0.0.1")
	insim = mock(InSim, CALL_REAL_FUNC)
	var lfs_connection := auto_free(LFSConnectionTCP.new()) as LFSConnectionTCP
	insim.add_child(lfs_connection)
	insim.lfs_connection = lfs_connection
	insim.initialize("127.0.0.1", 29_999, InSimInitializationData.new())


func test_send_message() -> void:
	insim.send_message("message")
	@warning_ignore("unsafe_method_access")
	var _interaction: GdUnitObjectInteractions = verify(insim, 1).send_message("message")
	@warning_ignore("unsafe_method_access")
	_interaction = verify(insim, 1).send_packet(any_object())


@warning_ignore("unused_parameter")
func test_send_message_split_long_messages(
	message: String, splits: Array[String], test_parameters := [
		[
			"test 1: 10  3456  20  3456  30  3456  40  3456  50  34567夢中",
			["test 1: 10  3456  20  3456  30  3456  40  3456  50  34567夢中"],
		],
		[
			"test 2: 10  3456  20  3456  30  3456  40  3456  50  345678夢中",
			["test 2: 10  3456  20  3456  30  3456  40  3456  50  345678夢中"],
		],
		[
			"test 3: 10  3456  20  3456  30  3456  40  3456  50  3456"
			+ "  60  3456  70  3456  80  3456  90  34夢中",
			[
				"test 3: 10  3456  20  3456  30  3456  40  3456  50  3456"
				+ "  60  3456  70  3456  80  3456  90  34",
				"夢中",
			],
		],
		[
			"test 4: 10  3456  20  3456  30  3456  40  3456  50  3456  60"
			+ "  3456  70  3456  80  3456  90  3夢中",
			[
				"test 4: 10  3456  20  3456  30  3456  40  3456  50  3456  60"
				+ "  3456  70  3456  80  3456  90  3",
				"夢中",
			],
		],
		[
			"test 5: 10  3456  20  3456  30  3456  40  3456  50  3456  60"
			+ "  3456  70  3456  80  3456  90 2夢中",
			[
				"test 5: 10  3456  20  3456  30  3456  40  3456  50  3456  60"
				+ "  3456  70  3456  80  3456  90 2",
				"夢中",
			],
		],
		[
			"test 6: 10  3456  20  3456  30  3456  40  3456  50  3456  60  3456  70"
			+ "  3456  80  3456  90  345  100  345  110  345  120  34夢中",
			[
				"test 6: 10  3456  20  3456  30  3456  40  3456  50  3456  60  3456  70"
				+ "  3456  80  3456  90  345",
				"  100  345  110  345  120  34夢中",
			],
		],
		[
			"test 7: 10  3456  20  3456  30  3456  40  3456  50  3456  60  3456  70"
			+ "  3456  80  3456  90  345  100  345  110  345  120  345  130"
			+ "  345  140  345  150  345  160  345  170  345  180  345  190"
			+ "  345  200",
			[
				"test 7: 10  3456  20  3456  30  3456  40  3456  50  3456  60  3456  70"
				+ "  3456  80  3456  90  345",
				"  100  345  110  345  120  345  130  345  140  345  150  345  160  345  170"
				+ "  345  180  345  190",
				"  345  200",
			],
		],
		[
			"test 8: 10  3456  20  3456  30  3456  40  3456  50  3456  60  34^6  70"
			+ "  3456  80  3456  90 2夢中",
			[
				"test 8: 10  3456  20  3456  30  3456  40  3456  50  3456  60  34^6  70"
				+ "  3456  80  3456  90 2",
				"^6夢中",
			],
		],
		[
			"test 9: 10  3456  20  3456  30  3456  40  3456  50  3456  60  34^6  70"
			+ "  3456  80  3456  90  345  100  345  110  345  120  345  130"
			+ "  345  140  345  150  345  160",
			[
				"test 9: 10  3456  20  3456  30  3456  40  3456  50  3456  60  34^6  70"
				+ "  3456  80  3456  90  345",
				"^6  100  345  110  345  120  345  130  345  140  345  150  345  160",
			],
		],
		[
			"test 10:10  3^56  20 ^3456  30  3456  40  34^6  50  3456  ^0  34^6  70"
			+ "  3456 ^80  3^56  90  345 ^100  345  ^90  3^5  120  345  130"
			+ " ^345  140  345  150  ^45  160",
			[
				"test 10:10  3^56  20 ^3456  30  3456  40  34^6  50  3456  ^0  34^6  70"
				+ "  3456 ^90  3^56  90  345",
				"^5 ^100  345  ^90  3^5  120  345  130 ^345  140  345  150  ^45  160",
			],
		],
		[
			# Test splitting right before a color code, with another color code already active.
			# Active color code should not be prepended if next message starts with color code.
			"test 11:10  3^56  20 ^3456  30  3456  40  34^6  50  3456  ^0  34^6  70"
			+ "  3456 ^80  3^56  90  345^1100  345  ^90  3^5  120  345  130"
			+ " ^345  140  345  150  ^45  160",
			[
				"test 11:10  3^56  20 ^3456  30  3456  40  34^6  50  3456  ^0  34^6  70"
				+ "  3456 ^90  3^56  90  345",
				"^1100  345  ^90  3^5  120  345  130 ^345  140  345  150  ^45  160",
			],
		],
	]
) -> void:
	insim.send_message(message)
	for split in splits:
		@warning_ignore("unsafe_method_access")
		var _interaction: GdUnitObjectInteractions = verify(insim, 1).send_message(split)
