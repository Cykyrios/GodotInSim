import Tabs from "@theme/Tabs";
import TabItem from "@theme/TabItem";

# InSim Utility classes

Godot InSim provides a few utility classes to help you track players in the server, fetch data about them,
as well as get the game's current state.

## Wording

Godot InSim uses the same terminology as the official InSim documentation. The main concept to grasp
about players is the distinction between *connected* players and *driving* players. They are defined as follows:
- A :class_ref[GISConnection] represents a player connected to the server. Each connection is attributed a **UCID**,
	or Unique Connection ID. This UCID is assigned when the player joins, and will uniquely identify them until
	they leave the server; at that point, another player joining the server may use the same UCID.
- A :class_ref[GISPlayer] represents a player who is currently driving. Each player is attributed a **PLID**,
	or PLayer ID. Like UCIDs, the PLID uniquely identifies the current driver, who will also have a reference
	to their corresponding connection through their UCID.

Note that LFS itself does not have a concept of connection or player; instead, it only uses UCIDs and PLIDs,
and expects InSim developers to maintain lists of those values for identification (this is what Godot InSim
handles for you through the :class_ref[GISConnection] and :class_ref[GISPlayer] objects).

## Connections

You can get the list of current connections through the
:class_ref[InSim.connections]{target="InSim#property_connections"} property, which is a :godot[Dictionary] mapping
UCIDs to :class_ref[GISConnection] objects. Using those, you can get the names (username and nickname) of all players
currently connected to the server, check whether they are admins, and get their current flags.

The most useful things to retrieve are probably the username or nickname (using the UCID that you can read from
some packets), or finding the UCID associated with a certain name.

```gdscript
# Assuming you have a ucid variable, e.g. obtained from an InSimVTNPacket
var player_name := insim.connections[ucid].nickname
```

In the above example, it is important that you check the key exists in the dictionary, as a missing key will crash
your app. You can do this in a few different ways:

```gdscript
player_name = insim.connections[ucid].nickname if ucid in insim.connections else "UCID not found"
player_name = insim.connections[ucid].nickname if insim.connections.has(ucid) else "UCID not found"
player_name = insim.connections.get(ucid, GISConnection.new()).nickname  # empty string if missing UCID

# You can also check the GISConnection object exists before trying to access its properties
var connection := insim.connections.get(ucid, null)
var player_name := connection.nickname if connection else "UCID %d not found" % [ucid]
```

If you need to find the UCID associated with a certain player's name, you can loop through the connections:

```gdscript
# Assuming you have a player_name variable containing a player's nickname
var player_ucid := -1
for ucid in insim.connections:
	if insim.connections[ucid].nickname == player_name:
	player_ucid = ucid
	break
```

In the above example, you should of course ensure the <Code>player_ucid</Code> is valid, i.e. not `-1`.

:::note

You will generally not need to do this, as all packets you receive that give you a player's name should also
include that player's UCID; one specific scenario could be identifying a player that is mentioned in a text
message typed by someone else.

:::

## Players

Similarly to connections, you can get the list of currently driving players through the
:class_ref[InSim.players]{target="InSim#property_players"} property, which is a :godot[Dictionary] mapping PLIDs
to :class_ref[GISPlayer] objects. Using those, you can get a player's UCID, their name, the vehicle they are driving,
or any property available in the :class_ref[GISPlayer] class. This class also provides a few utility functions to
parse the player flags, and check whether they are human or AI, local or remote, male or female (based on their
in-game character model).

For instance, you can check whether a player uses the expected restrictions on their vehicle:

```gdscript
# Assuming you have a plid variable obtained from a received packet
var player := insim.players[plid] if plid in insim.players else null
if not player:
	push_error("PLID %d not found" % [plid])  # for debugging purposes
	return  # if running from a separate function
# We check the restrictions: 20kg added mass and 10% intake restriction
if player.h_mass < 20 or player.h_tres < 10:
	insim.send_message("%s is using improper restrictions!" % [player.player_name])
```

## LFS State

Godot InSim also keeps track of the game's current state, updating it with each received :class_ref[InSimSTAPacket].
The current state is available through the :class_ref[InSim.lfs_state]{target="InSim#property_lfs_state"} property.
The :class_ref[LFSState] class contains the current number of connected players and driving players, race progress,
the current track, and a variety of other values. For instance, you can use it to check the current track at any time:

```gdscript
var track := insim.lfs_state.track
```

You can also use the state in local InSim apps to check what screen the player is currently on, whether they are in
:kbd[Shift]:kbd[U] view, etc.:

```gdscript
var shift_u_view := insim.lfs_state.flags & InSim.State.ISS_SHIFTU
```
