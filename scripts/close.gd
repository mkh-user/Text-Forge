extends AppScript

func _ready() -> void:
	need_file = true
	_load_shortcut()
	Signals.close_file.connect(func(): _run_action())

func _run_action() -> void:
	if Global.get_file_name().ends_with("*"):
		Signals.save_request.emit(id)
		return
	Global.set_file_name("There is no opened file")
	Global.set_file_path("")
	Global.set_editor_text("")
	Global.set_editor_disabled(true)
	Signals.check_options.emit()
