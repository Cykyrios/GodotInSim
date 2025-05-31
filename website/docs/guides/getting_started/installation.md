# Installation

To start building your InSim app, you only need to place this repository's `addons/godot_insim`
folder in your project's root directory, keeping the `addons` hierarchy.

<details>
<summary>Installing as a git submodule</summary>

You can add GodotInSim as a git submodule to your project: to prevent issues with Godot not
recognizing GodotInSim (because of the `project.godot` file), you should `git submodule add`
to a separate directory like `.submodules/godot_insim`, which you should add to your `.gitignore`
along with the `addons/godot_insim` directory. You should then copy the `post-checkout` git hook
to your `.git/hooks` directory, which will automatically symlink the `addons/godot_insim` directory
to your project after a checkout.

For an install-and-forget code snippet, you can do the following from your project root:
```bash
git submodule add -f --name godot_insim https://gitlab.com/Cykyrios/godot_insim.git .submodules/godot_insim
git submodule sync --recursive -- .submodules/godot_insim
git submodule update --init --recursive
mkdir -p addons
ln -s -r .submodules/godot_insim/addons/godot_insim ./addons/
```
</details>

You should also enable the `Godot InSim` plugin in **Project Settings > Plugins** to enable features
from autoloads.

From there, you can manually create and manage [InSim](./insim.md), [OutSim](./outsim/outsim.md) and
[OutGauge](./outgauge.md) nodes to communicate with LFS.

If you wish to connect to multiple InSim instances, you will need to create and manage several
[InSim](/class_ref/InSim.mdx) nodes.
