# REST API

An additional service provided by LFS is a
[REST API](https://www.lfs.net/forum/post/1969337#post1969337) to request information about
available mods. This API does not need LFS to be running, but it does require some setup to use.

## Authentication

Before you can use the REST API, you need to register your app: to do so, first open the
[API Access Management](https://www.lfs.net/account/api) page, and follow the instructions:

* Click **Register a new Application**.
* Fill the **name** and **display name** fields (I typed `GodotInSim` for both fields).
* The **Redirect URIs** field is mandatory, even if you don't need it: you can simply put `https://www.lfs.net` here.
* Check **Single Page Application** according to your needs.

After submitting this form, the next page will show a **Client ID** and a **Client Secret**;
save both of those (especially the secret, it won't show ever again) to a file, with the ID on
the first line, and the secret on the second line. This file will be read by GodotInSim to request
an access token: you need to read this file with your app to get the credentials.

Any time you make an API request, GodotInSim will try to use an existing access token, or request
a new one from the credentials in this file.

:::note

The access token is valid for one hour, and is stored in the `user://lfs_api/token.txt` file.

:::

:::danger

Do not add the credentials file to version control! You should never include credentials in version
control; put the file outside of your project entirely, or at the very least add it to your
`.gitignore` file.

:::

## Using the API

The REST API currently supports 2 request types:

* `LFSAPI.get_mod_list()` to retrieve the entire list of currently available mods, including basic
    info like the mod's ID and name, its version, WIP status, the vehicle type, etc.
* `LFSAPI.get_mod_details(skin_id)` to retrieve complete details about a single mod, including
    detailed engine specifications.

:::tip

If you don't need the full details for your purposes, consider fetching only the mod list, as you
can get every mod in a single request, while detailed mod info is only available for one mod per
request.

:::

An additional utility function is included to download a PNG image, which can be used to get a mod's
cover image.

For an example of actually using the API, refer to [this demo](/guides/demos/lfs_api/demo_lfs_api.md).
