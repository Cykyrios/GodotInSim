import type { PrismTheme } from "prism-react-renderer"

const theme: PrismTheme = {
  plain: {
    color: "#C9C9C9",
    backgroundColor: "#141414",
  },
  styles: [
    {
      types: ["region"],
      style: {
        color: "#AD75C4",
      },
    },
//    {
//      types: ["comment"],
//      style: {
//        color: "#CDCFD2",
//        opacity: 0.5,
//      },
//    },
//    {
//      types: ["doc-comment"],
//      style: {
//        color: "#99B3CC",
//        opacity: 0.8,
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
//        color: "#FFEDA1",
//      },
//    },
    {
      types: ["placeholder"],
      style: {
        color: "#FFC066",
      },
    },
    {
      types: ["escape"],
      style: {
        color: "#ABC9FF",
      },
    },
    {
      types: ["builtin-type"],
      style: {
        color: "#42FFC2",
      },
    },
    {
      types: ["builtin-object"],
      style: {
        color: "#8FFFDB",
      },
    },
//    {
//      types: ["class-name"],
//      style: {
//        color: "#C7FFED",
//      },
//    },
    {
      types: ["function-definition"],
      style: {
        color: "#66E6FF",
      },
    },
//    {
//      types: ["operator", "punctuation"],
//      style: {
//        color: "#ABC9FF",
//      },
//    },
    {
      types: ["control-flow"],
      style: {
        color: "#FF8CCC",
      },
    },
//    {
//      types: ["keyword", "operator-word", "builtin-pseudo"],
//      style: {
//        color: "#FF7085",
//      },
//    },
    {
      types: ["builtin"],
      style: {
        color: "#A3A3F5",
      },
    },
    {
      types: ["decorator"],
      style: {
        color: "#FFB373",
      },
    },
    {
      types: ["number"],
      style: {
        color: "#A1FFE0",
      },
    },
//    {
//      types: ["function"],
//      style: {
//        color: "#57B3FF",
//      },
//    },
    {
      types: ["property"],
      style: {
        color: "#BCE0FF",
      },
    },
    {
      types: ["variable"],
      style: {
        color: "#63C259",
      },
    },
    {
      types: ["node-path"],
      style: {
        color: "#B8C47D",
      },
    },
    {
      types: ["string-name"],
      style: {
        color: "#FFC2A6",
      },
    },
  ],
}
export default theme
