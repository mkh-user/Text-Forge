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
	var lines := Global.get_editor_text().split("\n")
	var cleaned := []
	var spacing_re := RegEx.new()
	spacing_re.compile("\\s*([=+\\-*/%<>&|^~!]=?|==|!=|<=|>=|\\*\\*|//)\\s*")

	for raw_line in lines:
		var indent_len := raw_line.length() - raw_line.lstrip(" \t").length()
		var indent := raw_line.substr(0, indent_len)
		var code := raw_line.lstrip(" \t")

		code = spacing_re.sub(code, " $1 ", true)
		code = code.replace(", ", ",")
		code = code.replace(",", ", ")
		code = code.replace("( ", "(")
		code = code.replace(" )", ")")
		code = code.replace(" :", ":")
		while code.find("  ") != -1:
			code = code.replace("  ", " ")

		cleaned.append(indent + code)

	Global.set_editor_text("\n".join(cleaned))
