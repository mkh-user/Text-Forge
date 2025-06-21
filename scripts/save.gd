extends AppScript

func _run_action() -> void:
	if main_window.get_file_label().tooltip_text == "Unsaved":
		Signals.script_run.emit(id + 1)
		return
	if not main_window.get_file_label().text.ends_with("*"): return
	_save_file(main_window.get_file_label().tooltip_text)
	main_window.get_file_label().text = main_window.get_file_label().text.replace("*", "")

func _save_file(path: String) -> void:
	match path.get_extension().to_lower():
		_:
			var file = FileAccess.open(path, FileAccess.WRITE)
			file.store_string(main_window.get_editor().text)
			file.close()
