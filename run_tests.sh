#!/bin/bash

# Run this script from the project root directory (Godot project or GodotInSim root).

# godot is assumed to be in PATH
export GODOT_BIN=godot

# Tests can be run for the GodotInSim project itself (standalone testing, e.g. for CI),
# or as an addon (for users).
# If the godot_insim addon directory exists, tests are run for addons/godot_insim/test.
# Otherwise, the current project is assumed to be GodotInSim itself,
# and the src and test directories are moved to addons/godot_insim for testing,
# with a godot.project file being created in the process (if godot.project already exists,
# exit with code 1).
godot_insim="addons/godot_insim"
if [ ! -d "${godot_insim}" ]; then
	if [ -f "project.godot" ]; then
		echo "${godot_insim} not found, but a Godot project already exists."
		echo "Exiting."
		exit 1
	fi
	echo "GodotInSim tests running in standalone mode"
	
	# Move code to the addons directory, as this is how GodotInSim is supposed to be used
	# (GdUnit4 paths also explicitly look for files in addons/godot_insim)
	mkdir -p ${godot_insim}
	mv src ${godot_insim}/src
	mv test ${godot_insim}/test

	touch project.godot
	godot --headless --import
fi

# Download GdUnit4

# Run GdUnit4 tests
./addons/gdUnit4/runtest.sh --headless --ignoreHeadlessMode -c -a ${godot_insim}/test
