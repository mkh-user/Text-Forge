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
	var indent_level := 0
	var section_indent := 0
	var indent_size := Global.get_editor().indent_size
	var indent_str := " ".repeat(indent_size) if Global.get_editor().indent_use_spaces else "\t"
	for line in lines:
		var trimmed := line.strip_edges()
		if trimmed.begins_with("\\end"):
			indent_level = max(indent_level - 1, 0)
		elif trimmed.begins_with("\\section"):
			section_indent = 0
		elif trimmed.begins_with("\\subsection"):
			section_indent = 1
		elif trimmed.begins_with("\\subsubsection"):
			section_indent = 2
		formatted.append(indent_str.repeat(indent_level + section_indent) + trimmed)
		if trimmed.begins_with("\\begin"):
			indent_level += 1
		elif trimmed.begins_with("\\section"):
			section_indent = 1
		elif trimmed.begins_with("\\subsection"):
			section_indent = 2
		elif trimmed.begins_with("\\subsubsection"):
			section_indent = 3
	Global.set_editor_text("\n".join(formatted))
