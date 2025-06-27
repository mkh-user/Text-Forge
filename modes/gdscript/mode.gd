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
	var lines := content.split("\n")
	var indent_level := 0
	var indent_str := " ".repeat(Global.get_editor().indent_size) if Global.get_editor().indent_use_spaces else "\t"

	for i in lines.size():
		var line := lines[i].strip_edges()
		if line.begins_with("else") or line.begins_with("elif"):
			indent_level = max(0, indent_level - 1)
		if line.begins_with("func") or line.begins_with("class"):
			indent_level = 0

		if line.begins_with("pass") or line == "":
			lines[i] = indent_str.repeat(indent_level) + line
			continue

		lines[i] = indent_str.repeat(indent_level) + line

		if line.ends_with(":") or line.ends_with("{") or line.ends_with("[") or line.ends_with("("):
			indent_level += 1
		elif line.begins_with("return") or line.begins_with("break"):
			indent_level = max(0, indent_level - 1)

	Global.set_editor_text("\n".join(lines))
