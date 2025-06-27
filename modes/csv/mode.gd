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
	var table := []
	var col_widths := []
	for line in lines:
		var row := line.split(",", false)
		table.append(Array(row).map(func(cell): return cell.strip_edges()))
		for i in row.size():
			var cell := row[i].strip_edges()
			if col_widths.size() <= i:
				col_widths.append(cell.length())
			else:
				col_widths[i] = max(col_widths[i], cell.length())
	var formatted := []
	for row: PackedStringArray in table:
		var line := []
		for i in row.size():
			line.append(row[i].rpad(col_widths[i]))
		formatted.append(", ".join(line))
	Global.set_editor_text("\n".join(formatted))
