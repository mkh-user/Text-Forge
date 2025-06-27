extends Node

func load_file(path) -> String:
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	return content

func save_file(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(Global.get_editor_text())
	file.close()

func auto_format() -> void:
	var content := Global.get_editor_text()
	var parsed = JSON.parse_string(content)
	if parsed == null:
		printerr("Invalid JSON!")
		return
	content = JSON.stringify(parsed, " ".repeat(Global.get_editor().indent_size) if Global.get_editor().indent_use_spaces else "\t")
	Global.set_editor_text(content)
