extends AppScript

func _ready() -> void:
	_load_shortcut()
	if not Global.get_editor().text_changed.is_connected(_check_undo):
		Global.get_editor().text_changed.connect(_check_undo)

func _run_action() -> void:
	Global.get_editor().undo()

func _check_undo() -> void:
	menu.set_item_disabled(menu.get_item_index(id), Global.get_editor().has_undo())
