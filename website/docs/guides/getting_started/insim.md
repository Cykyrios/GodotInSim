import Tabs from "@theme/Tabs";
import TabItem from "@theme/TabItem";

# InSim

Using InSim from Godot is straightforward: add an [InSim](/class_ref/InSim.mdx) node to your scene
and initialize it, then you can connect to one of its many signals to listen for specific packets,
and send packets manually or using the provided helper functions.

## Your first InSim app

### Hello InSim

Create a new scene (any base node will do, but you may want to use a :godot[Control]-based node
if you want to be able to display text; we will use simple `print` statements as a first step, so a
:godot[Node] will do), and add a script to it. You have 2 options to use InSim:

* Add an InSim node to your scene
* Create an InSim instance in code, and add it to the scene in the `_ready()` function.
* Actually, you also have the option to add it any other way you want, but let's keep things simple
    for now.

Let's add our InSim instance, assuming a :godot[Node] root for our scene:

<Tabs>
	<TabItem value="code" label="From code" default>
		```gdscript
		extends Node
		
		var insim: InSim = null
		
		func _ready() -> void:
			insim = InSim.new()
			add_child(insim)
		```
	</TabItem>
	<TabItem value="scene" label="From scene">
		```gdscript
		extends Node
		
		# You should make the InSim node unique to use the % syntax.
		@onready var insim: InSim = %InSim
		
		func _ready() -> void:
			add_child(insim)
		```
	</TabItem>
</Tabs>

Next we need to initialize the connection to InSim, so we can listen to packets sent by LFS, and send
our own packets. You can do this in `_ready()` or in a separate function:

```gdscript
insim.initialize(
	"127.0.0.1",
	29_999,
	InSimInitializationData.create(
		"My first InSim",
		InSim.InitFlag.ISF_LOCAL,
	),
)
```

You can refer to [InSimInitializationData](/class_ref/InSimInitializationData.mdx) for more details
on initialization, and [InSim.InitFlag](/class_ref/InSim.mdx#enum_InitFlag) for available
initialization flags.

With LFS running, let's make sure the game is listening for connections by typing `/insim 29999`.

If you added the above snippet to the `_ready()` function, launch the scene, and you should see LFS display the
following message:
> InSim - TCP : My first InSim

<details>
<summary>Troubleshooting</summary>

Did LFS not notice your InSim connection? Check the following points:

* Type `/insim 29999`, which should display "InSim : port 29999".
* Make sure you are using the correct IP address: this is a local program, so you need to use
    `"127.0.0.1"` in `initialize()`.
* Make sure the port corresponds to what LFS is listening to (`29999` in our example).
</details>

The `InSim.InitFlag.ISF_LOCAL` flag is not necessary here, but it is good practice to enable it for
any local InSim app, as it ensures InSim buttons you may add later on will not conflict with those
sent by the server you are connected to.

### Sending packets

Now that we are connected to LFS, the time has come to send our first packets. We will keep things simple
and send a text message using two different methods.

#### Sending specific packets

The standard way to send a packet is to create an instance of that [InSimPacket](/class_ref/InSimPacket.mdx)
using the [send_packet()](/class_ref/InSim.mdx#method_send_packet) method. To do this, we can
either create an instance of the packet, or use the `create()` static function that all sendable packets
have - the latter is recommended to avoid creating variables we may not be using at all after sending the packet.

<Tabs>
	<TabItem value="create" label="create()" default>
		```gdscript
		insim.send_packet(InSimMSTPacket.create("Hello InSim!"))
		```
	</TabItem>
	<TabItem value="instance" label="new instance">
		```gdscript
		var packet := InSimMSTPacket.new()
		packet.msg = "Hello InSim!"
		insim.send_packet(packet)
		var packet2 := InSimMSTPacket.create("Hello InSim!")  # This is equivalent to the first 2 lines.
		```
	</TabItem>
</Tabs>

#### Sending packets with helper functions

Some packets have wrapper functions to facilitate their use. Messages in particular are a very common thing
to send, but they come in various packet types:

* [InSimMSTPacket](/class_ref/InSimMSTPacket.mdx) for commands and messages
* [InSimMSXPacket](/class_ref/InSimMSXPacket.mdx) for longer messages
* [InSimMSLPacket](/class_ref/InSimMSLPacket.mdx) for local messages
* [InSimMTCPacket](/class_ref/InSimMTCPacket.mdx) for messages to specific connections or players

Instead of thinking of which packet to send every time, and their specificities, you can use the following
helper functions:
* [send_message](/class_ref/InSim.mdx#method_send_message) for both commands and messages: the
    packet type is determined automatically, and longer messages are split and sent in multiple packets.
* [send_local_message](/class_ref/InSim.mdx#method_send_local_message) for local messages
* [send_message_to_connection](/class_ref/InSim.mdx#method_send_message_to_connection) for messages
    to a specific connected player
* [send_message_to_player](/class_ref/InSim.mdx#method_send_message_to_player) for messages
    to a specific driving player

Instead of sending an [InSimMSTPacket](/class_ref/InSimMSTPacket.mdx), this time we will do the following:

```gdscript
insim.send_message("Hello InSim!")
```

:::caution Time is of the essence

While it would be nice to send this packet immediately after initialization, reality will be cruel, as
`initialize()` *requests* a new connection, but GodotInSim will only be connected once it has received a reply;
if we send a packet immediately, the connection is not established yet, and sending the packet will fail.

To avoid this problem, we can either wait for a short time with `await get_tree().create_timer(1).timeout`,
wait for the connection to be established, or send our message in response to an InSim event, i.e. a packet
received from LFS. Read on for the latter (and preferred) way of handling events.

:::

### Listening for packets

We will typically want to execute code in response to events in the game; to do that, we need to connect to
signals for the packets we are interested in. The
[packet_received](/class_ref/InSim.mdx#signal_packet_received) signal is emitted every time a packet
is received from LFS, but we usually want finer control, so we can instead connect to signals corresponding to
specific packets: if we want to know when a player has typed a message, we can connect to the
[isp_mso_received](/class_ref/InSim.mdx#signal_isp_mso_received) signal, which is emitted when an
[InSimMSOPacket](/class_ref/InSimMSOPacket.mdx) is received. For this, we will add the connection in the
`_ready()` function:

```gdscript
func _ready() -> void:
	# We are not repeating InSim initialization here
	var _connect := insim.isp_mso_received.connect(_on_mso_received)

func _on_mso_received(packet: InSimMSOPacket) -> void:
	print("MSO packet received: %s" % packet.msg)
```

Now, any time a message is sent in the game, we will have the message contents printed in the output.

### Waiting for something? (global signals)

Earlier on, we talked about having to wait for the connection to be established before sending packets;
the InSim node includes more signals than those related to packets:

* `connected` is emitted when the connection is established (this is detected by the first
    [InSimVERPacket](/class_ref/InSimVERPacket.mdx) received after initialization, as LFS responds with
    such a packet).
* `disconnected` is emitted when you [close](/class_ref/InSim.mdx#method_close) the connection,
    or when the connection times out.
* `timeout` is emitted after some time has passed with no packet being received; GodotInSim will send a ping
    to LFS if it hasn't received any packet for a while, and if no response is given within a few seconds,
    the connection is dropped.
* There are more signals, you can check out the list on the [InSim](/class_ref/InSim.mdx#signals) page.

### Putting it all together

Everything we have learned thus far allows us to make a very simple InSim app that sends a message when
connecting, and prints the contents of every message displayed in the game.

```gdscript
extends Node

var insim: InSim = null


func _ready() -> void:
	insim = InSim.new()
	add_child(insim)
	
	var _connect := insim.isp_mso_received.connect(_on_mso_received)

	insim.initialize(
		"127.0.0.1",
		29_999,
		InSimInitializationData.create(
			"My first InSim",
			InSim.InitFlag.ISF_LOCAL,
		),
	)
	
	await insim.connected
	insim.send_message("Hello InSim!")


func _on_mso_received(packet: InSimMSOPacket) -> void:
	print("MSO packet received: %s" % packet.msg)
```

Running this first app produces the following output in Godot:
```text
TCP connecting...
TCP status: connected - 127.0.0.1:29999
Connected to LFS 0.7F S3
Game InSim version matches local version (9)
Initializing Godot InSim...
Godot InSim is ready
MSO packet received: Player : Hello InSim!
```
The message we sent automatically when connecting is displayed in the game, which sends a corresponding
[InSimMSOPacket](/class_ref/InSimMSOPacket.mdx), so our app prints the contents of that message.
Of course, "Player" will be replaced with your own name.

## Sending and receiving packets in one go

GodotInSim also includes a number of helper functions to send a packet and immediately return a response packet
(or to be more precise, await the packet), or to await a packet without sending one first:

* [send_packet_await_packet](/class_ref/InSim.mdx#method_send_packet_await_packet) sends a packet and returns
    a response packet.
* [send_packet_await_packets](/class_ref/InSim.mdx#method_send_packet_await_packets) sends a packet and returns
    an array of response packets.
* [await_packet](/class_ref/InSim.mdx#method_await_packet) waits for and returns a packet.
* [await_packets](/class_ref/InSim.mdx#method_await_packet) waits for and returns an array of packets.

For instance, if you want to request information about the ongoing session with an
[InSimRSTPacket](/class_ref/InSimRSTPacket.mdx), you can do the following:

```gdscript
var packet: InSimRSTPacket = await insim.send_packet_await_packet(
	InSimTinyPacket.create(1, InSim.Tiny.TINY_RST),  # The packet you want to send
	Packet.ISP_RST,  # The packet type you expect
)
```

This would send a request for an [InSimRSTPacket](/class_ref/InSimRSTPacket.mdx), then return that packet
when GodotInSim receives it.

:::note

Only packets with the same `req_i` as your request will be returned, so there is no risk of intercepting
packets you didn't ask for (except if those packets were requested by other InSim apps using the same `req_i`).

:::

Additionally, you can add optional filters to the packet to return; this is especially useful to filter
specific subtypes of [InSimTinyPacket](/class_ref/InSimTinyPacket.mdx) or
[InSimSmallPacket](/class_ref/InSimSmallPacket.mdx):

```gdscript
var packet: InSimSmallPacket = await insim.send_packet_await_packet(
	InSimTinyPacket.create(1, InSim.Tiny.TINY_GTH),
	InSim.Packet.ISP_SMALL,
	{"subtype": InSim.Small.SMALL_RTP}
)
```

You can also retrieve an array of packets, using
[send_packet_await_packets](/class_ref/InSim.mdx#method_send_packet_await_packets), which takes
an additional parameter for the number of packets you expect to be returned. For instance, you can
request the list of players and expect the number of currently driving players.

Finally, you can use the await-only versions of the above methods, such as
[await_packet](/class_ref/InSim.mdx#method_await_packet), which allow you to await packets without
first sending another packet; those require an explicitly defined `req_i` to be passed, which will
likely be `0`, and as such is the default value.

:::info

All of the above methods must be awaited in code, and can therefore soft-lock your code: nothing will be
executed past a call to these methods until the awaited packets are returned. However, callbacks connected
to other signals will still execute while waiting for packets. You can use this to your advantage
to simplify code that requires a specific sequences of events.

For instance, the following code will print every [InSimLAPPacket](/class_ref/InSimLAPPacket.mdx) received
while waiting for the array of 5 packets to fill up, but any code after
[await_packets](/class_ref/InSim.mdx#method_await_packets) will have to wait until the array is returned:

```gdscript
var _connect := insim.isp_lap_received.connect(
	func(packet: InSimLAPPacket) -> void: print(packet.get_pretty_text())
)
var laps: Array[InSimPacket] = await_packets(InSim.Packet.ISP_LAP, 5)
```

:::

## A word on host InSim apps

We have only discussed local InSim connections so far, but you can also create a host InSim app.
Host apps connect directly to the host server, and not through your game: you don't need to have
LFS running on your PC for those. Whether you rent a server or start a host via the ingame interface,
you will need to get the host's IP and port, and use those to connect to InSim.

```gdscript
insim.initialize(
	"11.22.33.44",  # Set the host's IP address here
	12345,  # Set the host's port here
	InSimInitializationData.create(
		"My host InSim",
		0,  # Do not set the ISF_LOCAL flag, but you can set any other flag
		"!",  # Example prefix, optional
		"admin",  # You can set an admin password, which must match the host's
	),
)
# You can check for the host status of your app with the following condition
# (evaluates to true when running in multiplayer as server host).
if insim.is_host:
	# Execute host-specific code
```

## What's next?

Now that you know how to use InSim with GodotInSim, you can continue with the related `OutGauge` and `OutSim`,
you can [check out the demos](/guides/demos/intro.md), or you can start experimenting on your own!
