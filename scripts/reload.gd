extends AppScript

func _ready() -> void:
	_load_shortcut()
	menu.set_item_disabled(menu.get_item_index(id), Global.get_file_path() == "")

func _run_action() -> void:
	if Global.get_file_name().ends_with("*"):
		Signals.save_request.emit(id)
		return
	Signals.open_file.emit(Global.get_file_path())
