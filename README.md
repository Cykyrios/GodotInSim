# Godot InSim

This project aims to provide an API to build apps with the [Godot game engine](https://github.com/godotengine/godot) that can communicate with [Live For Speed](https://www.lfs.net) through its InSim protocol, as well as OutSim and OutGauge.

## Implementation and compatibility

Godot InSim currently supports InSim version 9.

InSim packets are implemented while keeping naming conventions as close as reasonably possible to LFS's InSim documentation, although some variable names are made more readable to adhere more closely to Godot's GDScript style guide.

Enums and bitflags are implemented as enums in `InSim`, `OutSim` and `OutGauge` as appropriate, some enums specific to a single type of packet can be included in the corresponding packet directly.

## Installation

To start building your InSim app, you only need to place this repository's contents in a subfolder of your project (`addons/godot_insim` is recommended). You can add it as a git submodule to your project.

From there, you can manually create and manage `InSim`, `OutSim` and `OutGauge` nodes to communicate with LFS.  
If you wish to connect to multiple InSim instances, you will need to create and manage several `InSim` nodes.

## Usage

### InSim initialization

You first have to initialize InSim by sending an IS_ISI packet, which is done by calling `initialize` on your `InSim` instance. You need to set the address and port in the InSim instance, you can also pass some initialization data that will set the packet accordingly, such as flags to enable receiving certain packets.  

### Sending packets

You can create new packets using the corresponding classes, named `InSimXXXPacket` where `XXX` is a packet identifier, e.g. `VER` for a version packet. Each class contains the variables from the corresponding `IS_XXX` struct.  
To send a packet, call `send_packet(packet)` on your `InSim` instance.  
General-purpose packets (ISP_TINY, ISP_SMALL and ISP_TTC) can be sent initialized with their values directly, e.g. `send_packet(InSimTinyPacket.new(1, InSim.Tiny.TINY_GTH))`.

### Receiving packets

Signals are provided to listen to incoming packets:

* `packet_received` is emitted for all incoming packets, and passes the packet as an `InSimPacket`.
* Each packet type also emits a corresponding signal, e.g. `isp_ver_packet_received` when receiving the version packet (ISP_VER). The packet is also passed as an `InSimXXXPacket`.
* Generic packets (ISP_TINY and ISP_SMALL) also emit signals for their subtypes, such as `tiny_clr_received`.

This allows you to listen to specific packets as well as handle any incoming packet.

### Included packet handling

As LFS pings the application with a specific packet (TINY_NONE) every 30 seconds, the corresponding reply is sent automatically to prevent timeouts.

The optional version request in the IS_ISI initialization packet is set to request a version packet, that you can check for InSim version compatibility.

All other packets are left to the user to handle.

## OutGauge

Direct OutGauge communication can be enabled without InSim by setting the appropriate settings in your `cfg.txt` file. Initialize the OutGauge socket with `initialize()` on your `OutGauge` instance to receive packets.

## OutSim

Direct OutSim communication can be enabled without InSim by setting the appropriate settings in your `cfg.txt` file. Initialize the OutSim socket with `initialize(outsim_options)` on your `OutSim` instance to receive packets. The `outsim_options` must be the same as the OutSimOpts in `cfg.txt`.

## Text handling

Text is automatically converted from UTF8 to LFS's format and vice versa. You can also use functions from the `LFSText` class to manually convert text, strip colors, as well as convert colors from BBCode to LFS color codes and vice versa for display in Godot's `RichTextLabel` or web pages. The class includes an array of colors and an enum with the corresponding indices.

## Miscellaneous

The `GISUtils` class includes general-purpose utility functions. There is currently a single set of unit conversion functions, if you want to compute some values directly from packets.  
All packets containing physical values have additional, corresponding variables starting with the `gis_` prefix (e.g. `gis_heading` or `gis_position` as a `Vector3(x, y, z)`). All `gis_*` variables use standard units: m, s, kg, N, W. Speeds use m/s, angles use radians. When sending such packets, you should prefer filling in the `gis_*` variables, as they use consistent units. They will be rounded to the packet's encoding precision. By default, all `gis_*` variables are used to set the packet's buffer; you can disable this behavior by setting `use_gis_values = false` after creating any packet.

## Example

A very simple example is provided as a demo in [this repository](https://github.com/Cykyrios/GodotInSim-Demo). The following images are from this demo.

![InSim](https://github.com/Cykyrios/GodotInSim-Demo/blob/main/examples/GodotInSim_demo.gif?raw=true)

![OutGauge and OutSim](https://github.com/Cykyrios/GodotInSim-Demo/blob/main/examples/GodotInSim_demo.png?raw=true)
