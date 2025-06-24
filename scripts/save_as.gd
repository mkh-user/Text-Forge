extends AppScript

var callback: int = -1
var dialog: FileDialog

func _ready() -> void:
	_load_shortcut()
	menu.set_item_disabled(menu.get_item_index(id), Global.get_file_path() == "")

func _run_action() -> void:
	dialog = preload("res://scripts/script_scenes/save_file.tscn").instantiate()
	dialog.file_selected.connect(_save_file)
	dialog.show()

func _save_file(path: String) -> void:
	match path.get_extension().to_lower():
		_:
			var file = FileAccess.open(path, FileAccess.WRITE)
			file.store_string(Global.get_editor_text())
			file.close()
	Global.set_file_name(path.get_file())
	Global.set_file_path(path)
	Signals.save_finished.emit(callback)
	callback = -1
