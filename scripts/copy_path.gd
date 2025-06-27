extends AppScript

func _ready() -> void:
	need_file = true
	_load_shortcut()

func _run_action() -> void:
	DisplayServer.clipboard_set(Global.get_file_path())
