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
	var lines := Array(Global.get_editor_text().split("\n"))
	lines = lines.map(func(item: String): return item.strip_edges())
	Global.set_editor_text("\n".join(lines))
