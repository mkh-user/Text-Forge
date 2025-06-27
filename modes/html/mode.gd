extends Node

var self_closing_tags := [
	"area", "base", "br", "col", "embed", "hr", "img", "input",
	"link", "meta", "param", "source", "track", "wbr"
]

func load_file(path) -> String:
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	return content

func save_file(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(Global.get_editor_text())
	file.close()

func split_tags(line: String) -> PackedStringArray:
	var result := []
	var regex := RegEx.new()
	regex.compile(r"(<[^>]+>)")
	var pos := 0
	for match in regex.search_all(line):
		if match.get_start() > pos:
			result.append(line.substr(pos, match.get_start() - pos).strip_edges())
		result.append(match.get_string().strip_edges())
		pos = match.get_end()
	if pos < line.length():
		result.append(line.substr(pos).strip_edges())
	return result

func auto_format() -> void:
	var content := Global.get_editor_text()
	var caret_line = Global.get_editor().get_caret_line()
	var scroll = Global.get_editor().get_v_scroll_bar().value
	var indent_level := 0
	var indent_str := " ".repeat(Global.get_editor().indent_size) if Global.get_editor().indent_use_spaces else "\t"
	var formatted := []

	var raw_lines := content.split("\n", false)
	var lines := merge_multiline_tags(raw_lines)

	for line in lines:
		var chunks := split_tags(line)
		for chunk in chunks:
			if chunk == "":
				continue
			chunk = clean_attribute_spacing(chunk)
			var tag_delta := count_tag_diff(chunk)
			if tag_delta < 0:
				indent_level = max(0, indent_level + tag_delta)
			formatted.append(indent_str.repeat(indent_level) + chunk)
			if tag_delta > 0:
				indent_level += tag_delta

	Global.set_editor_text("\n".join(formatted))
	Global.get_editor().set_caret_line(caret_line)
	Global.get_editor().set_caret_column(Global.get_editor().get_line(caret_line).length())
	Global.get_editor().get_v_scroll_bar().value = scroll

func clean_attribute_spacing(line: String) -> String:
	var cleaned := line
	var regex := RegEx.new()
	regex.compile(r'\s*=\s*')
	cleaned = regex.sub(cleaned, '=', true)
	regex.compile(r'\s{2,}')
	cleaned = regex.sub(cleaned, ' ', true)
	return cleaned.strip_edges()

func merge_multiline_tags(lines: PackedStringArray) -> PackedStringArray:
	var result := PackedStringArray()
	var buffer := ""
	var in_open_tag := false

	for line in lines:
		if not in_open_tag:
			buffer = line
			if line.count("<") > line.count(">") and not line.strip_edges().ends_with(">"):
				in_open_tag = true
			else:
				result.append(line)
		else:
			buffer += " " + line
			if ">" in line:
				result.append(buffer)
				buffer = ""
				in_open_tag = false

	if in_open_tag and buffer != "":
		result.append(buffer)

	return result



func count_tag_diff(line: String) -> int:
	var diff := 0
	var regex := RegEx.new()
	regex.compile("<(/?)(\\w+)[^>]*?>")
	var matches := regex.search_all(line)
	for match in matches:
		var closing := match.get_string(1) == "/"
		var tag := match.get_string(2).to_lower()
		var self_closing := tag in self_closing_tags or match.get_string(0).ends_with("/>")
		if self_closing:
			continue
		elif closing:
			diff -= 1
		else:
			diff += 1
	return diff
