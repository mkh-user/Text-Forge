extends ActionScript

var dialog: FileDialog

func _ready() -> void:
	_load_shortcut()
	Signals.open_file.connect(func(path): _open_file(path))

func _run_action() -> void:
	if Global.get_file_name().ends_with("*"):
		Signals.save_request.emit(id)
		return
	dialog = preload("res://scripts/script_scenes/open_file.tscn").instantiate()
	dialog.file_selected.connect(_open_file)
	add_child(dialog)
	dialog.show()


func _open_file(path: String) -> void:
	if not FileAccess.file_exists(path):
		Signals.editor_notification.emit(2, "Can't find this file!", "")
		return
	Global.set_file_name(path.get_file())
	Global.set_file_path(path)
	Global.get_editor_api().load_file(path)
	_append_to_recent_files(path)
	Signals.check_options.emit()


func _append_to_recent_files(path: String) -> void:
	var file = FileAccess.open(Global.get_core().RECENT_FILES_DATA, FileAccess.READ)
	var files = file.get_as_text() if FileAccess.file_exists(Global.get_core().RECENT_FILES_DATA) else ""
	if FileAccess.file_exists(Global.get_core().RECENT_FILES_DATA):
		file.close()
	file = FileAccess.open(Global.get_core().RECENT_FILES_DATA, FileAccess.WRITE)
	file.store_string(path + "\n" + files)
	file.close()
	Signals.update_recent_files.emit()
	menu.set_item_disabled(menu.get_item_index(id + 1), Global.get_core().recent_files_submenu.item_count == 0)
