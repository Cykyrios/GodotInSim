# Godot InSim

This project aims to provide an API to build apps with the [Godot game engine](https://godotengine.org/)
that can communicate with [Live For Speed](https://www.lfs.net) through its [InSim](/docs/guides/getting_started/insim)
protocol, as well as [OutSim](/docs/guides/getting_started/outsim), [OutGauge](/docs/guides/getting_started/outgauge)
and [InSimRelay](/docs/guides/getting_started/relay). It also contains tools to read and write various LFS file
formats, and provides access to the [REST API](/docs/guides/getting_started/rest_api).

## Installation and usage

Refer to the [guides](/docs/guides/intro) to get started.

## Implementation and compatibility

Godot InSim currently supports **InSim version 9** as of **LFS 0.7F5**.

InSim packets are implemented while keeping naming conventions as close as reasonably possible
to LFS's InSim documentation, although some variable names are made more readable to adhere
more closely to Godot's
[GDScript style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html).

Enums and bitflags are implemented as enums in [InSim](/docs/class_ref/InSim), [OutSim](/docs/class_ref/OutSim),
and [OutGauge](/docs/class_ref/OutGauge) as appropriate, some enums specific to a single type of packet can be
included in the corresponding packet directly. InSimRelay is handled directly by
[InSim](/docs/class_ref/InSim#class_InSim_property_is_relay).

Utility classes [GISCamera](/docs/class_ref/GISCamera), [GISTime](/docs/class_ref/GISTime), and
[GISUnit](/docs/class_ref/GISUnit) provide functions to convert data and manipulate Godot cameras.

All packets containing physical values have additional, corresponding variables starting with
the `gis_` prefix (e.g. `gis_heading` or `gis_position` as a `Vector3(x, y, z)`). All `gis_*`
variables use standard units: m, s, kg, N, W. Speeds use m/s, angles use radians. When sending
such packets, you should prefer filling in the `gis_*` variables, as they use consistent units.
They will be rounded to the packet's encoding precision. When creating a sendable packet, you can
choose to fill the packet's buffer from `gis_*` values or from standard InSim values.

## Demos

Demos showcasing some of GodotInSim's features are [available here](/docs/guides/demos/intro).
The following images are from some of those demos.

![Live Telemetry](/img/homepage/telemetry_2.jpg)

![Traffic Lights](/img/homepage/traffic_lights_2.jpg)

![Layout Viewer](/img/homepage/layout_viewer_gis.jpg)

![InSim Relay](/img/homepage/relay.jpg)
