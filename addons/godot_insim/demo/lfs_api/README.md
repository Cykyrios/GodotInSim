# LFS API

This demo showcases requests to the LFS API.

## Prerequisites

You need to register an app on the [API Access Management](https://www.lfs.net/account/api) page.
Documentation on the subject is rather poor, but for this demo, you can register a new app, give it
a URI of "https://www.lfs.net" (URI is mandatory, even though we are not using it here), and uncheck
the `Single Page Application` checkbox. Then save your `Client ID` and `Client Secret` to a text
file named `lfs_api.txt`, one line for each item, and place this file in the
`res://addons/godot_insim/secrets/` directory. For non-demo use, an **important note: do not
version control this file** (you should add `/addons/godot_insim/secrets/` to you `.gitignore`).

Doing this will give you access to the mod vehicles API, which does not require LFS authentication.

## How To

Launch the demo scene, which will request the list of currently available mods, print the number
of mods returned, then request and print details about one particular vehicle - a not-so-random
ID was chosen here ;). A final request is made for a non-existing mod ID (at least not at the time
of making this demo), to show the output of a failed request.

![LFS API mods](./screenshots/lfs_api_mods.jpg)
