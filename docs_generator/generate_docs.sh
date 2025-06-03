#!/bin/bash

bash addons/gdscript_xml_converter/bin/convert_xml.sh \
	-f mdx -i docs -o output -x res://addons/godot_insim/src \
	--allow-undocumented-enums
code=$?
if [ $code -ne 0 ]; then
	exit $code
fi
mv ./output/* ./website/docs/class_ref/
