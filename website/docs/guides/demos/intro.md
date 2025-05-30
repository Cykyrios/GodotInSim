import DocCardList from "@theme/DocCardList";

# GodotInSim Demos

Following are details about the demos included in GodotInSim. Each demo provides an overview
of the showcased features, specific prerequisites, and a description of the demo itself.

## General prerequisites

Unless stated otherwise, each demo needs to have InSim listening on port 29999 in LFS. There are
two ways you can achieve this:

* Type `/insim 29999` in the chat box in LFS
* Add a line with `/insim 29999` in the `autoexec.lfs` script found in the `data/script` folder
    of your LFS install (this will only take effect after restarting LFS).

## Demo-specific settings

Some demos have specific settings, such as **Project Settings**, that need to be enabled in order
to work properly; those are mentioned for any demo that requires them.

Some demos refer to default paths that you can (or should) modify: open the demo scene, select the
root node, and modify the values in the inspector.

<DocCardList />
