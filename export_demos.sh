#!/bin/bash

mkdir -p build/demo_layout_viewer/linux
mkdir -p build/demo_layout_viewer/windows
godot --headless --export-release "Linux Demo Layout Viewer" "build/demo_layout_viewer/linux/GIS Demo Layout Viewer.x86_64"
godot --headless --export-release "Windows Demo Layout Viewer" "build/demo_layout_viewer/windows/GIS Demo Layout Viewer.exe"
mkdir -p build/demo_pth_viewer/linux
mkdir -p build/demo_pth_viewer/windows
godot --headless --export-release "Linux Demo PTH Viewer" "build/demo_pth_viewer/linux/GIS Demo PTH Viewer.x86_64"
godot --headless --export-release "Windows Demo PTH Viewer" "build/demo_pth_viewer/windows/GIS Demo PTH Viewer.exe"
mkdir -p build/demo_relay/linux
mkdir -p build/demo_relay/windows
godot --headless --export-release "Linux Demo InSimRelay" "build/demo_relay/linux/GIS Demo InSimRelay.x86_64"
godot --headless --export-release "Windows Demo InSimRelay" "build/demo_relay/windows/GIS Demo InSimRelay.exe"
mkdir -p build/demo_telemetry/linux
mkdir -p build/demo_telemetry/windows
godot --headless --export-release "Linux Demo Telemetry" "build/demo_telemetry/linux/GIS Demo Telemetry.x86_64"
godot --headless --export-release "Windows Demo Telemetry" "build/demo_telemetry/windows/GIS Demo Telemetry.exe"
mkdir -p build/demo_teleporter/linux
mkdir -p build/demo_teleporter/windows
godot --headless --export-release "Linux Demo Teleporter" "build/demo_teleporter/linux/GIS Demo Teleporter.x86_64"
godot --headless --export-release "Windows Demo Teleporter" "build/demo_teleporter/windows/GIS Demo Teleporter.exe"
