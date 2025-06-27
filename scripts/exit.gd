extends AppScript

func _ready() -> void:
	_load_shortcut()
	get_window().close_requested.connect(func():_run_action())

func _run_action() -> void:
	if Global.get_file_name().ends_with("*"):
		Signals.save_request.emit(id)
		return
	SLib.exit()
