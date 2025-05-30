# LFS REST API

This demo showcases requests to the [LFS REST API](../../../class_ref/LFSAPI).

![REST API](./lfs_api_mods.jpg)

## Prerequisites

This demo does not need LFS to be running at all, but it requires credentials to the
[REST API](https://www.lfs.net/forum/post/1969337#post1969337); you need to register your app
on the [API Access Management](https://www.lfs.net/account/api) page.

Documentation on the subject is rather poor, so here's a quick breakdown:

* Click **Register a new Application**.
* Fill the **name** and **display name** fields (I typed `GodotInSim` for both fields).
* The **Redirect URIs** field is mandatory, even if you don't need it: you can simply put `https://www.lfs.net` here.
* Check **Single Page Application** according to your needs.

After submitting this form, the next page will show a **Client ID** and a **Client Secret**;
save both of those (especially the secret, it won't show ever again) to a file, with the ID on
the first line, and the secret on the second line. This file will be read by GodotInSim to request
an access token: you need to update the scene root's path to point to this file.

:::note

The access token is valid for one hour, and is stored in the `user://lfs_api/token.txt` file.

:::

## The demo

Upon launch, a few requests to the REST API are made: retrieve the list of mods, then display
details info an the cover picture for specific mods. Note that the `424242` mod ID is invalid,
and results in an error.

If no mods are found, make sure your credentials are valid, and the path to the credentials file
is correct. The default path is `res://addons/godot_insim/secrets/lfs_api.txt`.

:::danger

Do not add the credentials file to version control! There is no need to do so for the demo, but
for your own app, you should never include credentials in version control; put the file outside
of the project entirely, or at the very least add it to your `.gitignore`.

:::
