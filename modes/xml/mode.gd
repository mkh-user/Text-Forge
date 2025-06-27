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
	var text := Global.get_editor_text()
	text = text.replace("\n", "").replace("\r", "")
	var tokens := []
	var i := 0
	while i < text.length():
		if text[i] == "<":
			var j := text.find(">", i)
			if j == -1:
				break
			tokens.append(text.substr(i, j - i + 1))
			i = j + 1
		else:
			var j := text.find("<", i)
			if j == -1:
				tokens.append(text.substr(i))
				break
			tokens.append(text.substr(i, j - i))
			i = j

	var indent_level := 0
	var indent_size := Global.get_editor().indent_size
	var indent_str := " ".repeat(indent_size) if Global.get_editor().indent_use_spaces else "\t"
	var lines := []

	var buffer := ""
	for token in tokens:
		var trimmed: String = token.strip_edges()
		if trimmed.begins_with("</"):
			if buffer != "":
				lines.append(indent_str.repeat(indent_level) + buffer.strip_edges())
				buffer = ""
			indent_level = max(indent_level - 1, 0)
			lines.append(indent_str.repeat(indent_level) + trimmed)
		elif trimmed.begins_with("<") and trimmed.ends_with("/>"):
			if buffer != "":
				lines.append(indent_str.repeat(indent_level) + buffer.strip_edges())
				buffer = ""
			lines.append(indent_str.repeat(indent_level) + trimmed)
		elif trimmed.begins_with("<"):
			if buffer != "":
				lines.append(indent_str.repeat(indent_level) + buffer.strip_edges())
				buffer = ""
			lines.append(indent_str.repeat(indent_level) + trimmed)
			indent_level += 1
		else:
			buffer += trimmed

	if buffer != "":
		lines.append(indent_str.repeat(indent_level) + buffer.strip_edges())

	Global.set_editor_text("\n".join(lines))
