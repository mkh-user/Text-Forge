extends ActionScript

var callback: int = -1
var dialog: FileDialog

func _ready() -> void:
	need_file = true
	_load_shortcut()

func _run_action() -> void:
	dialog = preload("res://scripts/script_scenes/save_file.tscn").instantiate()
	dialog.file_selected.connect(_save_file)
	dialog.show()

func _save_file(path: String) -> void:
	Global.get_editor_api().save_file(path)
	Global.set_file_name(path.get_file())
	Global.set_file_path(path)
	Signals.save_finished.emit(callback)
	callback = -1
