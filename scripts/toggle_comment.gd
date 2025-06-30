extends ActionScript

func _run_action() -> void:
	if Global.get_editor().delimiter_comments.size() == 0: return
	var caret_pos: PackedVector2Array = []
	for i in Global.get_editor().get_caret_count():
		caret_pos.append(Vector2i(Global.get_editor().get_caret_line(i), Global.get_editor().get_caret_column(i)))
	for caret in Global.get_editor().get_caret_count():
		for line in range(Global.get_editor().get_selection_from_line(caret), Global.get_editor().get_selection_to_line(caret) + 1):
			if Global.get_editor().is_in_comment(line) != -1:
				var text = Global.get_editor_text()
				var lines = text.split("\n")
				lines[line] = lines.get(line).erase(0, Global.get_editor().get_comment_delimiters()[0].length())
				text = "\n".join(lines)
				Global.set_editor_text(text)
			else:
				var text = Global.get_editor_text()
				var lines = text.split("\n")
				lines[line] = Global.get_editor().get_comment_delimiters()[0] + lines.get(line)
				text = "\n".join(lines)
				Global.set_editor_text(text)
	@warning_ignore_start("narrowing_conversion")
	for j in caret_pos.size() - 1:
		Global.get_editor().add_caret(caret_pos[j].x, caret_pos[j].y)
	Global.get_editor().set_caret_line(caret_pos[0].x)
	Global.get_editor().set_caret_column(caret_pos[0].y)
