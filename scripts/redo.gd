extends ActionScript

func _ready() -> void:
	_load_shortcut()
	Global.get_editor().text_changed.connect(func(): _check_redo())

func _run_action() -> void:
	Global.get_editor().redo()

func _check_redo() -> void:
	menu.set_item_disabled(menu.get_item_index(id), not Global.get_editor().has_redo())
