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
	var lines := Global.get_editor_text().split("\n", false)
	var formatted := []
	for line in lines:
		var trimmed := line.strip_edges(false)
		if trimmed.begins_with("[") and trimmed.ends_with("]"):
			if formatted.size() > 0: formatted.append("")
			formatted.append(trimmed)
		elif trimmed.contains("="):
			var idx := trimmed.find("=")
			var key := trimmed.substr(0, idx).strip_edges()
			var val := trimmed.substr(idx + 1).strip_edges()
			formatted.append(key + " = " + val)
		else:
			formatted.append(trimmed)
	Global.set_editor_text("\n".join(formatted))
