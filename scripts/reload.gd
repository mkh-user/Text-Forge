extends AppScript

func _ready() -> void:
	need_file = true
	_load_shortcut()

func _run_action() -> void:
	if Global.get_file_path() == "Unsaved": return
	if Global.get_file_name().ends_with("*"):
		Signals.save_request.emit(id)
		return
	Signals.open_file.emit(Global.get_file_path())
