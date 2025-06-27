extends Node

func get_file_path() -> String:
	return get_main_node().file_label.tooltip_text

func get_file_name() -> String:
	return get_main_node().file_label.text

func set_file_path(path: String) -> void:
	get_main_node().file_label.tooltip_text = path

func set_file_name(file_name: String) -> void:
	get_main_node().file_label.text = file_name

func get_editor() -> Editor:
	return get_main_node().editor

func get_editor_text() -> String:
	return get_editor().text

func set_editor_text(text: String) -> void:
	get_editor().text = text

func set_editor_disabled(disabled: bool) -> void:
	get_editor().editable = not disabled

func is_editor_disabled() -> bool:
	return not get_editor().editable

func get_main_node() -> Core:
	return get_node("/root/Main")

func get_scripts_node() -> Node:
	return get_main_node().scripts

func get_editor_api() -> EditorAPI:
	return get_editor().get_child(0)
