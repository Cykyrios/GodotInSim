# Custom GDScript lexer (PrismJS) and themes (Prism React Renderer)

This folder contains the source file for the overhauled PrismJS GDScript lexer (see
[PR #3935 on GitHub](https://github.com/PrismJS/prism/pull/3935), along with light and dark themes
which are based on default colors from the Godot editor and a slight tweak to the background color
to make it closer to passivestar's theme.

Note that the theme requires some CSS, as it appears prism-react-renderer improperly colors all
keywords with the same alias as the standard keyword, so we work around that by removing the
definition from the typescript theme altogether, and move it to CSS instead.
