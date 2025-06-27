extends AppScript

var callback: int = -1

func _ready() -> void:
	need_file = true
	_load_shortcut()

func _run_action() -> void:
	if Global.get_file_path() == "Unsaved":
		main_window.scripts.get_node("save_as").callback = callback
		Signals.script_run.emit(id + 1)
		return
	if not Global.get_file_name().ends_with("*"): return
	_save_file(Global.get_file_path())
	Global.set_file_name(Global.get_file_name().replace("*", ""))

func _save_file(path: String) -> void:
	Global.get_editor_api().save_file(path)
	Signals.save_finished.emit(callback)
	callback = -1
