# OutGauge

Using OutGauge requires a bit more setup than InSim, but the overall logic is the same:
we listen for packets and execute code with the received data.

## Enabling OutGauge

You need to edit the `cfg.txt` file in the root folder of your LFS install.

:::warning

Make sure the game is *not* running while editing this file, otherwise your changes
may be overridden.

:::

At almost the end of the file, change the lines starting with `OutGauge` to the following:

```text
OutGauge Mode 2
OutGauge Delay 1
OutGauge IP 127.0.0.1
OutGauge Port 29998
OutGauge ID 0
```

* `Mode` controls where OutGauge is active: disabled/while driving/while driving and during replays.
* `Delay` controls how often packets are sent, as hundredths of a second.
* `IP` and `Port` control where the packets are sent.
* `ID` can be set to identify this connection.

## Receiving packets

Now that OutGauge is enabled, let's make a new scene based on :godot[Node] and attach a new script.

```gdscript
extends Node

var outgauge: OutGauge = null

func _ready() -> void:
	outgauge = OutGauge.new()
	add_child(outgauge)
	
	var _connect := outgauge.packet_received.connect(_on_packet_received)
	
	outgauge.initialize("127.0.0.1", 29998)
	# If you set IP to "127.0.0.1" and Port to 29998 in the cfg.txt file, you can omit them here.

func _on_packet_received(packet: OutGaugePacket) -> void:
	print("OutGauge packet received!")
```

Just like [InSim](./insim), you can create an OutGauge instance entirely from code, or add it
as a node in your scene and use <Code>@onready</Code>.

Initialization is even simpler than InSim: you only need to provide the address and port, and you
can even omit them if they match the default values.

We also add a callback function to print a message when packets are received.

Now launch the scene, launch the game if it's not already running, and start driving: you will see
packets coming in at a really fast pace. You can stop the test scene after a few seconds.

## What can we do with this?

OutGauge is primarily intended to be used for external dash displays, both on external monitors or
tablets/phones and custom-built cockpits. For instance, you can replicate the dash lights, get the
current speed, turbo gauge, fuel, engine RPM, etc.

All available data is detailed in :class_ref[OutGaugePacket]. This packet also provides a helper function
to get the available and currently turned on dash lights, so you don't need to decode the
[dash_lights](/class_ref/OutGaugePacket.mdx#property_dash_lights) and
[show_lights](/class_ref/OutGaugePacket.mdx#property_show_lights) values.

## A practical example: custom ABS light

In this section, we will create a very basic custom display showing when the ABS activates.
Create a new scene based on :godot[Control], add a :godot[ColorRect], give it a minimum size of
200x200, and make it black. We now have a nice square ready to light up.

Create a variable for the ColorRect, and change its value in <Code>_on_packet_received()</Code>:

```gdscript
@onready var color_rect: ColorRect = $ColorRect  # Prefer %ColorRect after making it unique

# Skipping the rest of the script

func _on_packet_received(packet: OutGaugePacket) -> void:
	var abs_on := packet.get_lights_array(packet.show_lights)[OutGaugePacket.DLFlags.DL_ABS]
	color_rect.color = Color.YELLOW if abs_on else Color.BLACK
```

That's all there is to it! Our black square will turn yellow any time ABS kicks in, matching the
dash light in the car.

:::note

Be aware that while most cars with ABS also have a dash light for it, some may not, so you cannot
rely on this to accurately determine when ABS kicks in; just keep in mind that this may not work
with some cars.

:::

## More ideas

With the dash lights, gauges, and throttle/brake inputs, you can create a complete virtual dash,
with custom alerts for some fuel levels or speed ranges, check whether a car's lights or turn signals
are on, etc. You can also trigger events via InSim, or combine this data with OutSim for even more
possibilities.
