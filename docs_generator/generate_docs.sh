#!/bin/bash

bash addons/gdscript_xml_converter/bin/convert_xml.sh -f mdx -i docs -o output -x res://addons/godot_insim/src
code=$?
if [ $code -ne 0 ]; then
	exit $code
fi
mkdir -p ./website/docs/class_ref
mv ./output/* ./website/docs/class_ref/
mkdir -p ./website/src/pages
cp ./README.md ./website/src/pages/index.md
