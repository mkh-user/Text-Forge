extends AppScript

func _ready() -> void:
	_load_shortcut()
	menu.set_item_disabled(menu.get_item_index(id), Global.get_file_path() == "")

func _run_action() -> void:
	DisplayServer.clipboard_set(Global.get_file_path())
