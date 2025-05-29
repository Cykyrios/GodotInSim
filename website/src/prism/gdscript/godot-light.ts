import type { PrismTheme } from "prism-react-renderer"

const theme: PrismTheme = {
  plain: {
    color: "#393939",
    backgroundColor: "#FFFFFF",
  },
  styles: [
//    {
//      types: ["comment"],
//      style: {
//        color: "#141414",
//        opacity: 0.5,
//      },
//    },
//    {
//      types: ["doc-comment"],
//      style: {
//        color: "#262666",
//        opacity: 0.7,
//      },
//    },
    {
      types: ["comment-critical"],
      style: {
        color: "#C45959",
      },
    },
    {
      types: ["comment-warning"],
      style: {
        color: "#B89C7A",
      },
    },
    {
      types: ["comment-notice"],
      style: {
        color: "#8FAB82",
      },
    },
//    {
//      types: ["string"],
//      style: {
//        color: "#996B00",
//      },
//    },
    {
      types: ["placeholder"],
      style: {
        color: "#EE9955",
      },
    },
    {
      types: ["escape"],
      style: {
        color: "#00009C",
      },
    },
    {
      types: ["builtin-type"],
      style: {
        color: "#009933",
      },
    },
    {
      types: ["builtin-object"],
      style: {
        color: "#1C8C66",
      },
    },
//    {
//      types: ["class-name"],
//      style: {
//        color: "#2E7366",
//      },
//    },
    {
      types: ["function-definition"],
      style: {
        color: "#009999",
      },
    },
//    {
//      types: ["operator", "punctuation"],
//      style: {
//        color: "#00009C",
//      },
//    },
    {
      types: ["control-flow"],
      style: {
        color: "#BD1FCC",
      },
    },
//    {
//      types: ["keyword", "operator-word", "builtin-pseudo"],
//      style: {
//        color: "#E62282",
//      },
//    },
    {
      types: ["builtin"],
      style: {
        color: "#5C2EB8",
      },
    },
    {
      types: ["decorator"],
      style: {
        color: "#CC5E00",
      },
    },
    {
      types: ["number"],
      style: {
        color: "#008C47",
      },
    },
//    {
//      types: ["function"],
//      style: {
//        color: "#0039E6",
//      },
//    },
    {
      types: ["property"],
      style: {
        color: "#0066AD",
      },
    },
    {
      types: ["variable"],
      style: {
        color: "#008000",
      },
    },
    {
      types: ["node-path"],
      style: {
        color: "#2E8C00",
      },
    },
    {
      types: ["string-name"],
      style: {
        color: "#CC8F73",
      },
    },
  ],
}
export default theme
