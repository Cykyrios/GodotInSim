# Godot InSim

This project aims to provide an API to build apps with the
[Godot game engine](https://godotengine.org/) that can communicate with
[Live For Speed](https://www.lfs.net) through its InSim protocol, as well as OutSim and OutGauge.

## Implementation and compatibility

Godot InSim currently supports InSim version 9 as of LFS 0.7F5.

InSim packets are implemented while keeping naming conventions as close as reasonably possible
to LFS's InSim documentation, although some variable names are made more readable to adhere
more closely to Godot's GDScript style guide.

Enums and bitflags are implemented as enums in `InSim`, `OutSim` and `OutGauge` as appropriate,
some enums specific to a single type of packet can be included in the corresponding packet directly.

## Installation

To start building your InSim app, you only need to place this repository's `addons/godot_insim` in
your project's root directory. Alternatively, you can add it as a git submodule to your project: to
prevent issues with Godot not recognizing GodotInSim (because of the project.godot file), you should
`git submodule add` to a separate directory like `.submodules/godot_insim`, which you should add to
your `.gitignore` along with the `addons/godot_insim` directory. You should then copy the
`post-checkout` git hook to your `.git/hooks` directory, which will automatically symlink the
`addons/godot_insim` directory to your project.

You should also enable the `Godot InSim` plugin to enable features from autoloads.

From there, you can manually create and manage `InSim`, `OutSim` and `OutGauge` nodes to communicate
with LFS.  
If you wish to connect to multiple InSim instances, you will need to create and manage several
`InSim` nodes.

## Usage

### InSim initialization

You first have to initialize InSim by sending an IS_ISI packet, which is done by calling
`initialize` on your `InSim` instance and passing the address and port you want to connect to,
as well as some initialization data that will set the packet accordingly, such as flags to enable
receiving certain packets. You can also set the protocol to use (TCP or UDP).

OutGauge and OutSim work similarly, but only need the address and port.

### Sending packets

You can create new packets using the corresponding classes, named `InSimXXXPacket` where `XXX` is
a packet identifier, e.g. `VER` for a version packet. Each class contains the variables from the
corresponding `IS_XXX` struct.  
To send a packet, call `send_packet(packet)` on your `InSim` instance.  
General-purpose packets (ISP_TINY, ISP_SMALL and ISP_TTC) can be sent initialized with their values
directly, e.g. `send_packet(InSimTinyPacket.create(1, InSim.Tiny.TINY_GTH))`.

### Receiving packets

Signals are provided to listen to incoming packets:

* `packet_received` is emitted for all incoming packets, and passes the packet as an `InSimPacket`.
* Each packet type also emits a corresponding signal, e.g. `isp_ver_received` when receiving the
version packet (ISP_VER). The packet is also passed as an `InSimXXXPacket`.
* Generic packets (ISP_TINY and ISP_SMALL) also emit signals for their subtypes, such as
`tiny_clr_received`.

This allows you to listen to specific packets as well as handle any incoming packet.

### Included packet handling

As LFS pings the application with a specific packet (TINY_NONE) every 30 seconds, the corresponding
reply is sent automatically to prevent timeouts.

The optional version request in the IS_ISI initialization packet is set to request a version packet
when calling `InSim.initialize()`, that you can check for InSim version compatibility.

Upon connection, `GodotInSim` will automatically send `TINY_NCN`, `TINY_NPL`, and `TINY_SST` packets
in order to receive an initial game state and a list of connections/players. Those can be accessed
via the `lfs_state` variable as well as the `connections` and `players` dictionaries, where the keys
correspond to the UCID/PLID of a each player, and the values are `Connection` and `Player` objects
containing info obtained in the `IS_NCN` and `IS_NPL` packets.

All other packets are left to the user to handle.

## OutGauge

Direct OutGauge communication can be enabled without InSim by setting the appropriate settings in
your `cfg.txt` file. Initialize the OutGauge socket with `initialize()` on your `OutGauge` instance
to receive packets.

## OutSim

Direct OutSim communication can be enabled without InSim by setting the appropriate settings in
your `cfg.txt` file. Initialize the OutSim socket with `initialize(outsim_options)` on your `OutSim`
instance to receive packets. The `outsim_options` must be the same as the OutSimOpts in `cfg.txt`.

## Text handling

Text is automatically converted from UTF8 to LFS's format and vice versa. The unicode text includes
LFS color codes `^0` through `^9` and uses two caret characters to represent a single one (e.g.
typing `a^b` in LFS will result in the string `a^^b`).

Utility functions for sending messages are provided with `send_message`, `send_local_message`,
`send_message_to_connection` and `send_message_to_player`. All of these support automatic message
splitting (sending multiple messages if your message doesn't fit in a single packet).

You can also use functions from the `LFSText` class to manually convert text, strip colors, convert
colors between LFS/BBCode/ANSI for display in Godot's `RichTextLabel`, web pages, or even terminals.
The `get_display_string` function converts colors (to BBCode by default) and removes duplicate
carets, so it can be displayed as it would appear in LFS.

Also included are car code conversion, utility functions to replace PLID/UCID numbers with player
names, regular expressions for colors and PLID/UCID.

## Miscellaneous

The `GISUtils` class includes general-purpose utility functions, such as unit conversion and
formatting for time strings (e.g. converting 123.45s to 2:03.45).

All packets containing physical values have additional, corresponding variables starting with
the `gis_` prefix (e.g. `gis_heading` or `gis_position` as a `Vector3(x, y, z)`). All `gis_*`
variables use standard units: m, s, kg, N, W. Speeds use m/s, angles use radians. When sending
such packets, you should prefer filling in the `gis_*` variables, as they use consistent units.
They will be rounded to the packet's encoding precision. When creating a sendable packet, you can
choose to fill the packet's buffer from `gis_*` values or from standard InSim values.

## Demos

Demos showcasing some of `GodotInSim`'s features are available in the
[demo folder](./godot_insim/demo/). The following images are from some of those demos.

![Random Lights](./godot_insim/demo/multiple_protocols/media/random_lights.webm)

![Live Telemetry](./godot_insim/demo/basic_telemetry/screenshots/telemetry_2.jpg)

![Layout Viewer](./godot_insim/demo/layout_viewer/screenshots/layout_viewer_gis.jpg)
