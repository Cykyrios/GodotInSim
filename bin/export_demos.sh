#!/bin/bash

while true; do
	case "$1" in
		--godot ) export GODOT_BIN="$2"; shift 2 ;;
		* ) break ;;
	esac
done

export GODOT_BIN="${GODOT_BIN:-godot}"

platforms=(
	"linux"
	"windows"
)
for platform in "${platforms[@]}"; do
	if [ "$platform" == "linux" ]; then
		extension=".x86_64"
	else
		extension=".exe"
	fi
	directory=build/demos/$platform/bin
	mkdir -p "$directory"
	$GODOT_BIN --headless --export-release "${platform^} Demo Executable" "$directory"/Godot_InSim"$extension"
	rm -f "$directory"/Godot_InSim.pck
done

demos=(
	"InSimRelay"
	"Layout Viewer"
	"Packet Logger"
	"PTH Viewer"
	"Telemetry"
	"Teleporter"
)
for demo in "${demos[@]}"; do
	demo_file=GIS_"${demo//\ /_}"
	$GODOT_BIN --headless --export-pack "Demo $demo" build/demos/"${demo_file}".pck
	echo -e "#!/bin/bash\n./bin/Godot_InSim.x86_64 --main-pack ./bin/${demo_file}.pck" >> build/demos/linux/"$demo_file".sh
	echo ".\\bin\\Godot_InSim.exe --main-pack .\\bin\\${demo_file}.pck" >> build/demos/windows/"$demo_file".bat
done

cd build/demos
for platform in "${platforms[@]}"; do
	if [ "$platform" == "linux" ]; then
		extension=sh
	else
		extension=bat
	fi
	cd "$platform"
	for script in *.$extension; do
		chmod +x "$script"
	done
	cd ..
	cp *.pck ./"$platform"/bin/
done
rm -f *.pck
