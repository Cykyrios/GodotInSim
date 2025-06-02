import Tabs from "@theme/Tabs";
import TabItem from "@theme/TabItem";

# InSim Relay

InSim Relay works in much the same way as standard [InSim](./insim.md) does: after establishing a
connection (to a specific IP/port), you can send and receive packets from the relay. The main
differences are the additional packet types that are specific to the relay, and the standard InSim
packets you are allowed to send through the relay.

:::note

The InSim Relay does not require LFS to be running at all, since it connects to an external IP.

:::

## Connecting to the relay

Connecting to the relay can be done in one of two ways: using the standard
[initialize](/class_ref/InSim.mdx#method_initialize) method with the specific IP
and port for the relay, which are available as constants in GodotInSim, or the dedicated
[initialize_relay](/class_ref/InSim.mdx#method_initialize_relay) method.

When you connect to the relay, the [is_relay](/class_ref/InSim.mdx#property_is_relay)
variable is set to `true`.

<Tabs>
	<TabItem value="initialize_relay" label="initialize_relay" default>
```gdscript
insim.initialize_relay()
```
	</TabItem>
	<TabItem value="initialize" label="initialize">
```gdscript
insim.initialize(
	InSim.RELAY_ADDRESS,
	InSim.RELAY_PORT,
	InSimInitializationData.new()  # Pass a new, empty InSimInitializationData.
)
```
	</TabItem>
</Tabs>

## Using the relay

The first thing you want to do when connecting to the relay is request the list of available hosts.
You can do so by sending a [RelayHLRPacket](/class_ref/RelayHLRPacket.mdx), to which the relay will
respond with a [RelayHOSPacket](/class_ref/RelayHOSPacket.mdx):

```gdscript
insim.send_packet(RelayHLRPacket.create(1))  # You need to pass a req_i (request ID)
```

From the list of hosts, you can then select a specific host to connect to by sending a
[RelaySELPacket](/class_ref/RelaySELPacket.mdx). For additional info on all the available packets,
refer to [InSimRelayPacket](/class_ref/InSimRelayPacket.mdx) and the inherited packets, and the
[documentation thread](https://www.lfs.net/forum/thread/30740) on the LFS forums.

:::note

The relay is also available via websockets; GodotInSim does not provide any helpers for websockets.

:::

## Example

The [InSim Relay demo](/guides/demos/relay/demo_relay.md) includes an example showing how you can use the
relay. The demo requests the list of hosts with a [RelayHLRPacket](/class_ref/RelayHLRPacket.mdx),
populates a list with the contents of the returned [RelayHOSPackets](/class_ref/RelayHOSPacket.mdx),
then sends a [RelaySELPacket](/class_ref/RelaySELPacket.mdx) when you click a host's name.

Upon connecting to the selected host, a standard [InSimTinyPacket](/class_ref/InSimTinyPacket.mdx)
is then sent to request the list of connected players, and the received
[InSimNCNPackets](/class_ref/InSimNCNPacket.mdx) are used to populate the connections list.
