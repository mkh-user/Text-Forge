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
	for i in lines.size():
		var line := lines[i].strip_edges()
		if line.begins_with("[") and line.ends_with("]"):
			lines[i] = "[ " + line.trim_prefix("[").trim_suffix("]").strip_edges() + " ]"
		elif "=" in line:
			var parts = line.split("=", false, 2)
			lines[i] = parts[0].strip_edges() + " = " + parts[1].strip_edges()
		else:
			lines[i] = line
	Global.set_editor_text("\n".join(lines))
