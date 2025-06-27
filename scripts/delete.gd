extends AppScript

var selected_caret_index: int = -1

func _ready() -> void:
	_load_shortcut()
	Signals.caret_selected.connect(func(index): selected_caret_index = index - 2)

func _run_action() -> void:
	if Global.get_editor().get_caret_count() == 1:
		Global.get_editor().delete_selection()
	else:
		var select_caret = PopupMenu.new()
		select_caret.add_separator("Select a caret to delete")
		select_caret.add_item("All")
		for caret in Global.get_editor().get_caret_count():
			select_caret.add_item("{0} (Line {1})".format([caret, Global.get_editor().get_caret_line(caret)]))
		select_caret.index_pressed.connect(func(index): Signals.caret_selected.emit(index))
		add_child(select_caret)
		select_caret.size = Vector2(400, 0)
		select_caret.popup_centered()
		await Signals.caret_selected
		select_caret.queue_free()
		Global.get_editor().delete_selection(selected_caret_index)
