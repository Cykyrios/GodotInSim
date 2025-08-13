# InSim Buttons

You can build custom user interfaces with Godot InSim in two different ways:
- by sending raw packets with the :class_ref[InSimBTNPacket] and :class_ref[InSimBFNPacket] classes;
- by leveraging the included :class_ref[InSimButtonManager] through the functions in :class_ref[InSim].

We will go through both methods, with more emphasis on the second one, as it should make working with
buttons easier. You can also refer to the [InSim Buttons demo](/docs/guides/demos/insim_buttons), which
features both methods.

## Using native IS_BTN packets

### Creating buttons

The only way to get buttons to display in LFS is to send an `IS_BTN` packet, which you can do directly
using the :class_ref[InSimBTNPacket.create()]{target="InSimBTNPacket#method_create"} function:

```gdscript
insim.send_packet(
	InSimBTNPacket.create(
		0,  # ucid
		42,  # click_id
		0,  # inst
		InSim.ButtonStyle.ISB_DARK | InSim.ButtonColor.ISB_TITLE,  # style
		0,  # type_in
		50,  # left
		50,  # top
		30,  # width
		5,  # height
		"Hello Button!",  # text
		"",  # caption
	)
)
```

:class_ref[InSimBTNPacket] allows creating raw `IS_BTN` packets almost exactly as the InSim specification
expects, the main difference being the handling of the caption: instead of including it in the `text` string,
Godot InSim concatenates both string with the appropriate formatting.

Sending this button works locally (since we sent the button to UCID 0); on a host connection, while the button
will technically exist, there will be no one to see it.

- `ucid` must be 0 (local, or host for a remote connection), 255 (send the button to everyone), or a specific
	value corresponding to the player you want to send the button to.
- `click_id` must be unique for every UCID: if you try to send a packet with `click_id` 10 to UCID 0 when
	such a button already exists, the new button will replace the previous one. You can however have multiple
	UCIDs with different buttons for the same `click_id` value.
- `inst` is only used for a specific flag, where the value `128` makes the button visible at all times, instead
	of getting hidden on some screens or when typing text.
- `style` can be a combination of flags from the :class_ref[InSim.ButtonStyle]{target="InSim#enum_ButtonStyle"}
	and :class_ref[InSim.ButtonColor]{target="InSim#enum_ButtonColor"} enumerations.
- `type_in` is used to specify how many characters the player can input in the chat box when clicking the button.
	For this to work, `style` must include `ISB_CLICK`. Note that codepage changes, color codes, and multibyte
	characters all count toward the limit, so a value of 10 won't always let you type in 10 characters.
- `left` and `top` define the position of the button's top-left corner, mapped on your screen from a 200x200 canvas.
	Similarly, `width` and `height` define the button's dimensions. Note that the button's `height` also dictates
	the text's font size; text that is too long to fit the button will get squished horizontally.
- `text` contains the visible text in the button, and can be empty.
- `caption` is the text shown when clicking the button, if `type_in` is non-zero. This field is a Godot InSim
	helper to avoid dealing with null bytes when trying to add both text and a caption.

### Deleting buttons

If you want to delete a button, you can use the `IS_BFN` packet with the appropriate values; like `IS_BTN`, you can
use the :class_ref[InSimBFNPacket.create()]{target="InSimBFNPacket#method_create"} function:

```gdscript
insim.send_packet(
	InSimBFNPacket.create(
		InSim.ButtonFunction.BFN_DEL_BTN,  # subtype
		0,  # ucid
		5,  # click_id
		20,  # click_max
	)
)
```

- `subtype` can be `BFN_CLEAR` to clear all buttons made by the :class_ref[InSim] instance (ignoring all other
	parameters) or `BFN_DEL_BTN`, in which case you can delete specific buttons.
- `ucid` is the target player you want to delete buttons for.
- `click_id` is the same as the one in `IS_BTN`.
- `click_max` works similarly to `click_id`, and serves to define a `click_id` range to delete buttons; it can be
	`0` to select only the given `click_id`.

### Limitations of raw packets

While sending raw packets works, it also means you need to manage UCIDs and clickIDs, to make sure you don't
accidentally replace an existing button. You also need to remember what every clickID corresponds to, or structure
your code to remember those things for you.

In the next section, we will have a look at how Godot InSim can help you in this regard, by including high-level
button objects you can create, update and delete, and an internal button manager that handles raw packets for you.

## Button Manager

Godot InSim includes an :class_ref[InSimButtonManager], which allows you to work with button objects that you can
name, and provides utility functions to find buttons from their clickIDs, their names, a prefix in their names,
or a regular expression. It also allows you to use a single button object that can map its text to every player
in the server, while handling clickIDs automatically, within an ID range you can set to suit your needs.

### Creating buttons

:class_ref[InSim] exposes two functions to create an :class_ref[InSimButton]:
- :class_ref[add_solo_button()]{target="InSim#method_add_solo_button"}: Creates an :class_ref[InSimSoloButton];
	this is the closest to the raw `IS_BTN` packet, as this object is assigned to a single UCID, and holds
	a single clickID.
- :class_ref[add_multi_button()]{target="InSim#method_add_multi_button"}: Creates an :class_ref[InSimMultiButton],
	which can hold multiple :class_ref[UCIDMapping]s, i.e. button information for a given UCID, including
	the clickID, text, caption, and type_in value.

:class_ref[InSimSoloButton] is a simple object: you assign values to it, and a packet is sent to the corresponding
player. On the other hand, :class_ref[InSimMultiButton] allows for more interesting possibilites:
- You can choose specific players who will receive the button, some applications can include:
	- Safety car and rescue vehicles in a race
	- Groups of cars, for instance in multi-class events
	- In cruise servers, every player driving a certain vehicle type or belonging to a specific group (police, etc.)
- The button can also be global, which means every player connected to the server will receive it, and players who
	connect later will also receive it upon joining the server.
- You can add and remove UCID mappings after creating the button, with
	:class_ref[add_ucid_mapping()]{target="InSimMultiButton#method_add_ucid_mapping"} and
	:class_ref[remove_ucid_mapping()]{target="InSimMultiButton#method_remove_ucid_mapping"}.
- You can tailor the button's contents to every UCID mapping, which can allow you to:
	- include the player's name or vehicle in the button, or any value specific to that UCID
	- assign randomly-generated values to each UCID
	- display data from your own UCID mappings; this can include timers, arbitrary states,
		or anything you can think of.

The format for adding buttons is slightly different from :class_ref[InSimBTNPacket]:

```gdscript
insim.add_solo_button(
	0,  # ucid
	Vector2i(50, 5),  # position
	Vector2i(30, 5),  # size
	InSim.ButtonStyle.ISB_LIGHT | InSim.ButtonColor.ISB_UNSELECTED,  # style
	"Hello button!",  # text
	"my_solo_button",  # button_name
	10,  # type_in
	"Enter up to 10 characters",  # caption
	false,  # show_everywhere
)
insim.add_multi_button(
	[],  # ucids
	Vector2i(50, 10),  # position
	Vector2i(30, 5),  # size
	InSim.ButtonStyle.ISB_DARK | InSim.ButtonColor.ISB_TEXT,  # style
	func(ucid: int) -> String:  # text
		return insim.get_connection_nickname(ucid)
	"my_multi_button",  # button_name
	0,  # type_in
	"",  # caption
	false,  # show_everywhere
)
```

All parameters after `text` are optional. The above code creates 2 buttons:
- a first button displaying "Hello button!" in a black font over a light background;
- a second button displaying your name in a light blue font over a dark background.

The first button is only shown to you (single player) or the host (multiplayer, when running remotely),
as it is sent to UCID 0. The second button is shown to every player in the server (when running as a remote host),
with the text showing each player their own name. :class_ref[InSimMultiButton]'s `text` parameter can take
a simple :godot[String] or a :godot[Callable], as in the example above; `caption` and `type_in` also accept
:godot[Callable] parameters for extended customzation.

:::note

Both methods include a last, optional parameter named `sender`; you should ignore this parameter, as its only use
is for identifying [GIS Hub](https://godot-insim.gitlab.io/gis-hub) modules, an extension to Godot InSim that
allows you to build, distribute and use multiple "InSim apps" from a single InSim connection, with the ability
to enable or disable those modules at any time, and including features like automatic button clickID assignment
from a shared pool, module options and configuration, and advanced GUI capabilities.

:::

### Retrieving button objects

In the previous example, we created 2 buttons. While doing so, we gave those buttons names, which we can use
to retrieve the button objects. There are a few different ways to find created buttons:
- :class_ref[get_button_by_id()]{target="InSim#method_get_button_by_id"}
- :class_ref[get_button_by_name()]{target="InSim#method_get_button_by_name"}
- :class_ref[get_buttons_by_id_range()]{target="InSim#method_get_buttons_by_id_range"}
- :class_ref[get_buttons_by_prefix()]{target="InSim#method_get_buttons_by_prefix"}
- :class_ref[get_buttons_by_regex()]{target="InSim#method_get_buttons_by_regex"}

For instance, we can get both buttons with the following call:

```gdscript
var buttons := insim.get_buttons_by_prefix("my_")
```

All of the above methods allow filtering by UCID, and default to not filtering at all.

:::tip

Name your buttons! As we just saw, Godot InSim provides 3 methods to find buttons from their names,
or part of their names. Take advantage of this to organize your buttons in meaningful hierarchies,
using prefixes like you would use folders.

Also make sure to avoid duplicate names, as it can affect the returned value from
:class_ref[get_button_by_name()]{target="InSim#method_get_button_by_name"}.

:::

### Updating buttons

Just like you can update a button by sending an :class_ref[InSimBTNPacket] while leaving its position and size
values as zero, you can call :class_ref[update_solo_button()]{target="InSim#method_update_solo_button"} to
change an :class_ref[InSimSoloButton]'s `text`, `caption`, and `type_in`. The corresponding :class_ref[InSimBTNPacket]
will be sent automatically.

For an :class_ref[InSimMultiButton], call :class_ref[update_multi_button()]{target="InSim#method_update_multi_button"},
with the added possibility of passing a :godot[Callable] for each value instead. For every UCID mapping of the
button that was modified, a corresponding :class_ref[InSimBTNPacket] is sent.

### Deleting buttons

Deleting buttons requires a reference to one or more :class_ref[InSimButton] objects. You can delete a single object
with :class_ref[delete_button()]{target="InSim#method_delete_button"}, or several at once with
:class_ref[delete_buttons()]{target="InSim#method_delete_buttons"}. For both methods, you can pass an array of `ucids`
to filter the players that will have their buttons deleted; an empty array disables filtering, so all found buttons
are deleted.

:::note

UCID filtering only works for :class_ref[InSimMultiButton], and using it means the button object itself might not get
deleted, if there are still valid UCID mappings remaining.

:::

As an attempt at bandwith optimization, when deleting multiple buttons at once (as in multiple button mappings, not
just multiple :class_ref[InSimButton] objects), the :class_ref[InSimButtonManager] will attempt to sort UCIDs and
clickIDs to make use of the `click_id, click_max` syntax and send as few packets as possible.

## A practical example

Once again, you can refer to the [buttons demo](/docs/guides/demos/insim_buttons), which features both raw packets
and buttons managed by the :class_ref[InSimButtonManager]. The code is available on the Godot InSim repository.
