import {findAndReplace} from "mdast-util-find-and-replace"
import {visit} from "unist-util-visit"

function getAbbreviationTitle(text: string): string {
  const abbreviations = new Map<string, string>([
    ["bitfield", "This value is an integer composed as a bitmask of the following flags."],
    ["const", "This method has no side effect. It doesn't modify any of the instance's member variables."],
    ["constructor", "This method is used to construct a type."],
    ["operator", "This method describes a valid operator to use with this type as left-hand operand."],
    ["static", "This method doesn't need an instance to be called, so it can be called directly using the class name."],
    ["vararg", "This method accepts any number of arguments after the ones described here."],
    ["virtual", "This method should typically be overridden by the user to have any effect."],
    ["void", "No return value"],
  ]);
  return abbreviations.has(text) ? abbreviations.get(text) : "Error: undefined abbreviation";
}

const plugin = (options) => {
  const transformer = async (ast) => {
    visit(ast, (node) => {
      if (node.type === "textDirective") {
        if (node.name === "abbr") {
          const text = node.children[0].value;
          node.data = {
            hName: "abbr",
            hProperties: {
              title: node.attributes.title ? node.attributes.title : getAbbreviationTitle(text),
            },
          };
        } else if (node.name === "godot") {
          const text = node.children[0].value;
          node.data = {
            hName: "a",
            hProperties: {
              href: `https://docs.godotengine.org/en/stable/classes/class_${text.toLowerCase()}.html`,
            },
          };
        } else if (node.name === "kbd") {
          node.data = {
            hName: "kbd",
          }
        }
      } else if (node.type === "leafDirective") {
        if (node.name === "hr") {
          node.data = {
            hName: "hr",
            hProperties: node.attributes,
          };
        } else if (node.name === "center") {
          node.data = {
            hName: "center",
          }
        }
      }
    });
  };
  return transformer;
};

export default plugin;
