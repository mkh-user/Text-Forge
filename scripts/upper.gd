extends AppScript

func _run_action() -> void:
	Global.get_editor().begin_complex_operation()
	Global.get_editor().begin_multicaret_edit()
	var text = Global.get_editor_text()
	var selections = []
	for caret in Global.get_editor().get_caret_count():
		var selected_text = Global.get_editor().get_selected_text(caret)
		selections.append([Vector2i(Global.get_editor().get_selection_origin_line(caret), Global.get_editor().get_selection_origin_column(caret)), Vector2i(Global.get_editor().get_caret_line(caret), Global.get_editor().get_caret_column(caret))])
		var selected_origin = Global.get_editor().get_char_index(Global.get_editor().get_selection_origin_line(caret), Global.get_editor().get_selection_origin_column(caret))
		var selected_caret = Global.get_editor().get_char_index(Global.get_editor().get_caret_line(caret), Global.get_editor().get_caret_column(caret))
		var new_text = text.substr(0, selected_origin) + selected_text.to_upper() + text.substr(selected_caret)
		text = new_text
	Global.set_editor_text(text)
	Global.get_editor().end_multicaret_edit()
	for i in selections.size():
		Global.get_editor().add_caret(selections[i][1].x, selections[i][1].y)
		Global.get_editor().select(selections[i][0].x, selections[i][0].y, selections[i][1].x, selections[i][1].y, i)
	Global.get_editor().end_complex_operation()
	Global.get_editor().text_changed.emit()
