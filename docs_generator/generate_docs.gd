#!/usr/bin/env -S godot --headless -s
extends SceneTree
## Doc generation script
##
## This script generates the XML files for the addons folder, converts them to MDX, moves them
## to the website/docs/class_ref directory, generates the class reference index, and finally
## copies and replaces some text in the README.md file to make it the site's home page.

const CONFIG_PATH := "res://addons/gdscript_xml_converter/config.cfg"
const URL := "https://gitlab.com/Cykyrios/godot_insim/-/blob/main/"


func _initialize() -> void:
	await execute_or_exit(set_configuration)
	await execute_or_exit(generate_docs)
	await execute_or_exit(generate_index)
	await execute_or_exit(update_readme)
	quit(0)


func execute_or_exit(callable: Callable) -> void:
	var result := callable.call() as int
	if result > 0:
		quit(result)
	await process_frame


func generate_docs() -> int:
	var dict := OS.execute_with_pipe(
		"/bin/bash", ["-c", "./docs_generator/generate_docs.sh"], false
	)
	var pid := dict.pid as int
	var stdio := dict.stdio as FileAccess
	var stderr := dict.stderr as FileAccess
	while OS.is_process_running(pid):
		if stdio.is_open():
			printraw(stdio.get_buffer(stdio.get_length()).get_string_from_utf8())
		if stderr.is_open():
			printraw(stderr.get_buffer(stderr.get_length()).get_string_from_utf8())
	var exit_code := OS.get_process_exit_code(pid)
	print(exit_code)
	if exit_code > 0:
		push_error("Doc generation failed with code %d" % [exit_code])
	return exit_code


func generate_index() -> int:
	var file := FileAccess.open("grouped_classes.json", FileAccess.READ)
	if not file:
		var error := FileAccess.get_open_error()
		push_error("Failed to open \"grouped_classes.json\": error %d" % [error])
		return error
	var groups := JSON.parse_string(file.get_as_text()) as Dictionary
	var sidebar := FileAccess.open("website/classref_sidebar.ts", FileAccess.WRITE)
	if not sidebar:
		var error := FileAccess.get_open_error()
		push_error("Failed to open classref_sidebar.ts: error %d" % [error])
		return error

	var indent_level := 0
	var make_indent := func make_indent(level: int) -> String:
		return "  ".repeat(level)

	var contents := "import type {SidebarConfig} from \"@docusaurus/plugin-content-docs\";\n\n"
	contents += "const classrefSidebar: SidebarConfig = [\n"
	indent_level = 2
	contents += "%s{\n%stype: \"category\",\n%slabel: \"Class Reference\",\n%slink: {\n" % [
		make_indent.call(indent_level - 1),
		make_indent.call(indent_level),
		make_indent.call(indent_level),
		make_indent.call(indent_level),
	]
	contents += "%stype: \"doc\",\n%sid: \"class_ref/intro\",\n" % [
		make_indent.call(indent_level + 1),
		make_indent.call(indent_level + 1),
	]
	contents += "%s},\n%sitems: [\n" % [
		make_indent.call(indent_level),
		make_indent.call(indent_level),
	]
	indent_level = 4
	var add_category := func add_category(group: Dictionary, depth: int) -> String:
		var category := ""
		var current_indent := indent_level + depth * 2
		category += "%s{\n%stype: \"category\",\n%slabel: \"%s\",\n%slink: {\n" % [
			make_indent.call(current_indent - 1),
			make_indent.call(current_indent),
			make_indent.call(current_indent),
			group["label"],
			make_indent.call(current_indent),
		]
		category += "%stype: \"generated-index\",\n%stitle: \"%s\",\n" % [
			make_indent.call(current_indent + 1),
			make_indent.call(current_indent + 1),
			group["label"],
		]
		category += "%s},\n%sitems: [\n" % [
			make_indent.call(current_indent),
			make_indent.call(current_indent),
		]
		var class_list := group["classes"] as Array
		for group_class in class_list as Array[Dictionary]:
			category += "%s\"class_ref/%s\",\n" % [
				make_indent.call(current_indent + 1),
				group_class["class"],
			]
		category += "%s],\n%s},\n" % [
			make_indent.call(current_indent),
			make_indent.call(current_indent - 1),
		]
		return category
	for group in groups as Dictionary[String, Dictionary]:
		var group_dict := groups[group] as Dictionary
		var group_splits := (group_dict["group"] as String).split(ClassGroup.SEPARATOR)
		var depth := group_splits.size() - 1
		var category := add_category.call(group_dict, depth) as String
		if depth == 0:
			contents += category
		else:
			var parent_splits := group_splits.duplicate()
			parent_splits.remove_at(parent_splits.size() - 1)
			var parent_category := ClassGroup.SEPARATOR.join(parent_splits).strip_edges()
			parent_category = groups[parent_category]["label"]
			var regex := RegEx.create_from_string(
				"(?m) +type: \"category\",\\n +label: \"%s\",\\n" % [parent_category]
				+ "(?:.+\\n)*?( +)items: \\[\\n"
			)
			var result := regex.search(contents)
			if not result:
				push_error("Failed to find parent category %s for subcategory %s" % [
					parent_category, group_dict["label"]
				])
				continue
			var closing_regex := RegEx.create_from_string(
				"(?:.+?\\n)(?=%s\\],\\n)" % [result.strings[1]]
			)
			var insert_pos := closing_regex.search(contents, result.get_end(1)).get_end()
			contents = contents.insert(insert_pos, category)
	contents += "%s],\n%s},\n];\n" % [
		make_indent.call(2),
		make_indent.call(1),
	]
	contents += "\nexport default classrefSidebar;\n"
	var _error := sidebar.store_string(contents)
	return 0


func set_configuration() -> int:
	var config := ConfigFile.new()
	var error := config.load(CONFIG_PATH)
	if error != OK:
		push_error("Failed to open config.cfg, aborting")
		return 1
	config.set_value("config", "class_groups_path", "res://docs_generator/class_groups.json")
	config.set_value("config", "fail_on_class_ref_issues", false)
	error = config.save(CONFIG_PATH)
	if error != OK:
		push_error("Failed to update config.cfg, aborting")
		return 1
	return 0


func update_readme() -> int:
	var file := FileAccess.open("./website/src/pages/index.md", FileAccess.READ_WRITE)
	if not file:
		var error := FileAccess.get_open_error()
		push_error("Failed to open \"index.md\": error %d" % [error])
		return error
	var text := file.get_as_text()
	text = RegEx.create_from_string(r"```sh").sub(text, "```bash", true)
	var url_regex := RegEx.create_from_string(r"(?<=.\])\((.+?)\)")
	var results := url_regex.search_all(text)
	for i in results.size():
		var result := results[-1 - i]
		if result.strings[1].begins_with("http"):
			continue
		text = url_regex.sub(
			text, "(%s%s)" % [URL, result.strings[1].trim_prefix("/")], false, result.get_start()
		)
	file.seek(0)
	var _discard := file.store_string(text)
	file.close()
	return 0
