The `post-checkout` hook in this directory should be copied to `.git/hooks` in your project and
made executable (or if the files already exist, the contents should be appended,
excluding potential duplicate commands).

The contents should be adjusted as required for your own submodules/addons (you can
remove GdUnit4 if you don't use it in your project). You should uncomment the GodotInSim
section to enable the GodotInSim symlink.

This has to be done manually, hooks cannot be updated automatically.

Assuming you cloned GodotInSim into `.submodules/godot_insim`, the `post-checkout` hook
updates the symlink to `addons/godot_insim` in your project.

You should also add the following entries to your `.gitignore`:
```
# Submodule and plugin management
.submodules/
addons/godot_insim
```

If you would rather clone GodotInSim in a different location, update the hook accordingly.
