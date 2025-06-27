extends AppScript

func _ready() -> void:
	need_file = true
	_load_shortcut()

func _run_action() -> void:
	OS.shell_show_in_file_manager(Global.get_file_path())
