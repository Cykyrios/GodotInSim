# Text Handling

Text is automatically converted from UTF8 to LFS and vice versa. The unicode text includes LFS color codes
`^0` through `^9` and uses two circumflex characters to represent a single one (e.g. typing `a^b` in LFS
will result in the string `a^^b`).

Utility functions for sending messages are provided with
[send_message](/class_ref/InSim.mdx#method_send_message),
[send_local_message](/class_ref/InSim.mdx#method_send_local_message),
[send_message_to_connection](/class_ref/InSim.mdx#method_send_message_to_connection),
and [send_message_to_player](/class_ref/InSim.mdx#method_send_message_to_player).
All of these support automatic message splitting (sending multiple messages if your message doesn't fit
in a single packet).

You can also use functions from the [LFSText](/class_ref/LFSText.mdx) class to manually convert text,
strip colors, convert colors between LFS/BBCode/ANSI for display in Godot's :godot[RichTextLabel], web pages,
or even terminals. The [get_display_string](/class_ref/LFSText.mdx#method_get_display_string)
function converts colors (to BBCode by default) and removes duplicate circumflex characters, so it can be
displayed as it would appear in LFS.

Also included are car code conversion, utility functions to replace PLID/UCID numbers with player
names, regular expressions for colors and PLID/UCID.
