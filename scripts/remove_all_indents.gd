extends ActionScript

func _run_action() -> void:
	var caret = Vector2i(Global.get_editor().get_caret_line(), Global.get_editor().get_caret_column())
	var lines := Array(Global.get_editor_text().split("\n"))
	lines = lines.map(func(line: String): return line.strip_edges())
	Global.set_editor_text("\n".join(lines))
	Global.get_editor().set_caret_line(caret.x)
	Global.get_editor().set_caret_column(caret.y)
