import type {SidebarsConfig} from "@docusaurus/plugin-content-docs";
import { default as classrefSidebar } from "./classref_sidebar.ts"

const sidebars: SidebarsConfig = {
  "classrefSidebar": classrefSidebar,
  "guidesSidebar": [
    {
      type: "doc",
      id: "guides/intro",
      label: "Introduction",
    },
    {
      type: "category",
      label: "Getting Started",
      link: {
        type: "doc",
        id: "guides/getting_started/intro",
      },
      items: [
        "guides/getting_started/installation",
        "guides/getting_started/insim",
        "guides/getting_started/outgauge",
        "guides/getting_started/outsim",
        "guides/getting_started/relay",
        "guides/getting_started/rest_api",
        "guides/getting_started/text_handling",
      ],
    },
    {
      type: "category",
      label: "Demos",
      link: {
        type: "doc",
        id: "guides/demos/intro",
      },
      items: [
        "guides/demos/basic_telemetry/demo_basic_telemetry",
        "guides/demos/buttons/demo_buttons",
        "guides/demos/layout_viewer/demo_layout_viewer",
        "guides/demos/lfs_api/demo_lfs_api",
        "guides/demos/mixed_tcp_udp/demo_mixed_tcp_udp",
        "guides/demos/multiple_protocols/demo_multiple_protocols",
        "guides/demos/packet_logger/demo_packet_logger",
        "guides/demos/pth_viewer/demo_pth_viewer",
        "guides/demos/relay/demo_relay",
        "guides/demos/teleporter/demo_teleporter",
        "guides/demos/traffic_lights/demo_traffic_lights",
      ],
    },
  ],
};

export default sidebars;
