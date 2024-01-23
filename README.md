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

## Example

A very simple example is provided as a demo in [this repository](https://github.com/Cykyrios/GodotInSim-Demo). The following images are from this demo.

![InSim](https://github.com/Cykyrios/GodotInSim-Demo/blob/main/examples/GodotInSim_demo.gif?raw=true)

![OutGauge and OutSim](https://github.com/Cykyrios/GodotInSim-Demo/blob/main/examples/GodotInSim_demo.png?raw=true)
