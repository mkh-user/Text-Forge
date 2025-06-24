extends AppScript

var dialog: FileDialog

func _ready() -> void:
	_load_shortcut()
	if not Signals.open_file.is_connected(_open_file):
		Signals.open_file.connect(_open_file)

func _run_action() -> void:
	if Global.get_file_name().ends_with("*"):
		Signals.save_request.emit(id)
		return
	dialog = preload("res://scripts/script_scenes/open_file.tscn").instantiate()
	dialog.file_selected.connect(_open_file)
	dialog.show()


func _open_file(path: String) -> void:
	if not FileAccess.file_exists(path):
		SLib.send_alert("Can't find this file!", "Text Forge - Alert")
		return
	Global.set_file_name(path.get_file())
	Global.set_file_path(path)
	_load_file(path)
	_load_edit_mode(path)
	_append_to_recent_files(path)
	Signals.check_options.emit()


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
			Global.set_editor_disabled(false)
			Global.set_editor_text(file.get_as_text())
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
