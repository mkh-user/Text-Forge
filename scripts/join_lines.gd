extends ActionScript

func _run_action() -> void:
	for caret in Global.get_editor().get_caret_count():
		if caret >= Global.get_editor().get_caret_count():
			printerr("Join lines for multi carets is not supported yet!")
			break
		var sel_text = Global.get_editor().get_selected_text(caret)
		if sel_text == "": continue
		var lines: Array = sel_text.split("\n")
		lines = lines.map(func(item): return item.strip_edges())
		var joined := " ".join(lines)
		var start: Vector2i
		if Global.get_editor().get_char_index(Global.get_editor().get_selection_origin_line(caret), Global.get_editor().get_selection_origin_column(caret)) > Global.get_editor().get_char_index(Global.get_editor().get_caret_line(caret), Global.get_editor().get_caret_column(caret)):
			start = Vector2i(Global.get_editor().get_caret_line(caret), Global.get_editor().get_caret_column(caret))
		else:
			start = Vector2i(Global.get_editor().get_selection_origin_line(caret), Global.get_editor().get_selection_origin_column(caret))
		Global.set_editor_text(Global.get_editor_text().substr(0, Global.get_editor().get_char_index(start.x, start.y)) + joined + Global.get_editor_text().substr(Global.get_editor().get_char_index(start.x, start.y) + sel_text.length()))
		Global.get_editor().select(start.x, 0, start.x, Global.get_editor().get_line(start.x).length(), caret)
	Global.get_editor().text_changed.emit()
