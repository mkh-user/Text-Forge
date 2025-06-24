extends AppScript

var callback: int = -1

func _ready() -> void:
	menu.set_item_disabled(menu.get_item_index(id), Global.get_file_path() == "")

func _run_action() -> void:
	if Global.get_file_path() == "Unsaved":
		main_window.scripts.get_node("save_as").callback = callback
		Signals.script_run.emit(id + 1)
		return
	if not Global.get_file_name().ends_with("*"): return
	_save_file(Global.get_file_path())
	Global.set_file_name(Global.get_file_path().replace("*", ""))

func _save_file(path: String) -> void:
	match path.get_extension().to_lower():
		_:
			var file = FileAccess.open(path, FileAccess.WRITE)
			file.store_string(Global.get_editor_text())
			file.close()
	Signals.save_finished.emit(callback)
	callback = -1
