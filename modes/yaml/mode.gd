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
	var lines := content.split("\n", false)
	var formatted := []
	var indent_level := 0
	var indent_size := Global.get_editor().indent_size
	var indent_str := " ".repeat(indent_size) if Global.get_editor().indent_use_spaces else "\t"
	for i in lines.size():
		var line := lines[i].strip_edges(false)
		if line == "":
			formatted.append("")
			continue
		if line.strip_edges().begins_with("-"):
			line = line.substr(0, line.find("-")) + "- " + line.substr(line.find("-") + 1).strip_edges()
		if line.begins_with(" ") == false and (line.find(":") == -1 or line.ends_with(":")) == false:
			indent_level = 0
		var colon_idx := line.find(":")
		if colon_idx > -1:
			var key := line.substr(0, colon_idx).strip_edges()
			var value := line.substr(colon_idx + 1).strip_edges()
			line = key + ":"
			if value != "":
				line += " " + value
		if line.begins_with("- "):
			formatted.append(indent_str.repeat(indent_level) + line)
		else:
			formatted.append(indent_str.repeat(indent_level) + line)
		if line.ends_with(":"):
			indent_level += 1
	Global.set_editor_text("\n".join(formatted))
