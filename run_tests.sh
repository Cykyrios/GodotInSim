#!/bin/bash

# Run this script from the project root directory (Godot project or GodotInSim root).

# godot is assumed to be in PATH, and GdUnit4 located at addons/gdUnit4
export GODOT_BIN=godot

./addons/gdUnit4/runtest.sh --headless --ignoreHeadlessMode -c -a ${godot_insim}/test
