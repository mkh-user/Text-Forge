extends AppScript

var dialog: FileDialog

func _run_action() -> void:
	dialog = preload("res://scripts/script_scenes/save_file.tscn").instantiate()
	dialog.file_selected.connect(_save_file)
	dialog.show()

func _save_file(path: String) -> void:
	match path.get_extension().to_lower():
		_:
			var file = FileAccess.open(path, FileAccess.WRITE)
			file.store_string(main_window.get_editor().text)
			file.close()
	main_window.get_file_label().text = path.get_file()
	main_window.get_file_label().tooltip_text = path
