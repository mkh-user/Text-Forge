extends AppScript

var dialog: FileDialog

func _ready() -> void:
	Signals.open_file.connect(_open_file)

func _run_action() -> void:
	dialog = preload("res://scripts/script_scenes/open_file.tscn").instantiate()
	dialog.file_selected.connect(_open_file)
	dialog.show()


func _open_file(path: String) -> void:
	if not FileAccess.file_exists(path): return
	main_window.get_file_label().text = path.get_file()
	main_window.get_file_label().tooltip_text = path
	_load_file(path)
	_load_edit_mode(path)
	_append_to_recent_files(path)


func _append_to_recent_files(path: String) -> void:
	var file = FileAccess.open(main_window.RECENT_FILES_DATA, FileAccess.READ)
	var files = file.get_as_text() if FileAccess.file_exists(main_window.RECENT_FILES_DATA) else ""
	if FileAccess.file_exists(main_window.RECENT_FILES_DATA):
		file.close()
	file = FileAccess.open(main_window.RECENT_FILES_DATA, FileAccess.WRITE)
	file.store_string(path + "\n" + files)
	file.close()
	main_window.update_recent_files()
	menu.set_item_disabled(menu.get_item_index(id + 1), main_window.recent_files_submenu.item_count == 0)


func _load_file(path: String) -> void:
	match path.get_extension().to_lower():
		_:
			var file = FileAccess.open(path, FileAccess.READ)
			main_window.get_editor().text = file.get_as_text()
			main_window.get_editor().editable = true
			file.close()


func _load_edit_mode(path: String) -> void:
	match path.get_extension().to_lower():
		"gd":
			main_window.set_edit_mode(2)
		"md":
			main_window.set_edit_mode(3)
		"json":
			main_window.set_edit_mode(5)
		"ini", "cfg":
			main_window.set_edit_mode(6)
		_:
			main_window.set_edit_mode(1)
