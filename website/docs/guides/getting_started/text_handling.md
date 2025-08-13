# Text Handling

Text is automatically converted from UTF8 to LFS and vice versa. The unicode text includes LFS color codes
`^0` through `^9` and uses two circumflex characters to represent a single one (e.g. typing `a^b` in LFS
will result in the string `a^^b`, and you will need to type `^^` from GodotInSim when you want to send
a message containing only `^` in LFS).

The reason for this is that text encoding in LFS is still based on
an outdated format from early Windows systems, which uses the circumflex character for escape sequences.
That encoding was extended to support many characters from non-latin languages, as well as symbols, but
still relies on the same basic principles.

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

## Displaying a received message

Assuming a player named `Player` typed the following message:

> <span style={{color: "lime"}}>Hello</span> <span style={{color: "red"}}>InSim</span>!
> <span style={{color: "white"}}>This</span> is a <span style={{color: "magenta"}}>very</span>
> <span style={{color: "yellow"}}>colorful</span> ^<span style={{color: "cyan"}}>message</span>^.

LFS will send an [InSimMSOPacket](/class_ref/InSimMSOPacket.mdx) with the following message:

> ^7Player ^7: ^8^2Hello ^1InSim^9! ^7This ^9is a ^5very ^3colorful ^9^^^6message^9^^.

If you want to display this message, including the actual colors, in a :godot[RichTextLabel], or
print it directly to the output panel, you can then do the following, assuming we have a `packet`
variable of type [InSimMSOPacket](/class_ref/InSimMSOPacket.mdx):

```gdscript
rich_text_label.text = LFSText.get_display_string(packet.msg)  # Requires enabling BBCode
print_rich(LFSText.get_display_string(packet.msg))
```

Both of the above options will print the message as it was originally typed in LFS (including
the sender's name), as color codes are converted to BBCode tags, and remaining double circumflex
characters are escaped. The string actually passed to the :godot[RichTextLabel] or the
`print_rich()` method is the following:

> \[color=#ffffff]Player \[/color]\[color=#ffffff]: \[/color]
> \[color=#00ff00]Hello \[/color]\[color=#ff0000]InSim\[/color]! \[color=#ffffff]This \[/color]is a
> \[color=#ff00ff]very \[/color]\[color=#ffff00]colorful \[/color]^\[color=#00ffff]message\[/color]^.

### Retrieving the sender's name and the message contents

[InSimMSOPackets](/class_ref/InSimMSOPacket.mdx) contain both the sender's name and the message
itself. You can retrieve those separately by calling the corresponding [LFSText](/class_ref/LFSText.mdx)
methods [get_mso_sender](/class_ref/LFSText.mdx#method_get_mso_sender) and
[get_mso_message](/class_ref/LFSText.mdx#method_get_mso_message):

```gdscript
print_rich(LFSText.get_display_string(LFSText.get_mso_sender(packet, insim)))
print_rich(LFSText.get_display_string(LFSText.get_mso_message(packet, insim)))
```

This will print the following:

> <span style={{color: "white"}}>Player</span>
>
> <span style={{color: "lime"}}>Hello</span> <span style={{color: "red"}}>InSim</span>!
> <span style={{color: "white"}}>This</span> is a <span style={{color: "magenta"}}>very</span>
> <span style={{color: "yellow"}}>colorful</span> ^<span style={{color: "cyan"}}>message</span>^.

:::note

Passing the [InSim](/class_ref/InSim.mdx) instance to those methods is necessary to properly cut
the message, as the [ISF_MSO_COLS](/class_ref/InSim.mdx#enum_InitFlag_constant_ISF_MSO_COLS) flag
determines whether color codes are included in the message.

:::

:::tip

If you want to properly identify the sender, consider using the `plid` or `ucid` properties from
the packet instead, you can then get all data about the sender using `players[packet.plid]` or
`connections[packet.ucid]`.

:::

## Sending colored messages

You can of course include colors in messages sent from GodotInSim to LFS, but you have to keep a few
points in mind:

* You can (and should) use the provided color codes in
    [LFSText.ColorCode](/class_ref/LFSText.mdx#enum_ColorCode), or input them manually if you prefer.
* Do not try to apply colors other than those, as they will not work.
* Convert colors using the methods provided by [LFSText](/class_ref/LFSText.mdx) if your input message
    is colored in BBCode or ANSI colors.
* ANSI colors use 8-bit colors to ensure colors are identical to LFS; however, this may cause some
    terminals to not display them properly (support should be pretty much universal, but you never
    know; standard color codes are not used as the actual color depends on each implementation, and
    often avoids fully-saturated colors).

The following example shows different ways of writing the same message:

```gdscript
"This is a ^1red ^9word."
"This is a ^%dred ^%dword." % [LFSText.ColorCode.RED, LFSText.ColorCode.DEFAULT]
"This is a %sred %sword." % [
    LFSText.get_color_code(LFSText.ColorCode.RED),
    LFSText.get_color_code(LFSText.ColorCode.DEFAULT),
]
```

:::note

The default color `^9` can vary in LFS: it is <span style={{color: "lime"}}>green</span> in text messages,
<span style={{color: "yellow"}}>yellow</span> in `/me` messages, <span style={{color: "gray"}}>gray</span>
in local messages, and maybe more. GodotInSim uses a gray default color.

:::

## Sending messages in other languages

All LFS code pages are supported, so you should be able to send a message in any language, and the
text should convert properly.

> ```gdscript
> insim.send_message("Hello ^7日^1本^7語^9 InSim!")
> ```
>
> LFS displays: <span style={{color: "white"}}>Player : </span>Hello
> <span style={{color: "white"}}>日</span><span style={{color: "red"}}>本</span><span style={{color: "white"}}>語</span>
> InSim!

Emoji and a number of Unicode symbols are not supported by LFS.

> ```gdscript
> insim.send_message("⚠ Warning ⚠")
> ```
>
> LFS displays: <span style={{color: "white"}}>Player : </span>? Warning ?
