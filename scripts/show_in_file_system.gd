extends AppScript

func _ready() -> void:
	menu.set_item_disabled(menu.get_item_index(id), Global.get_file_path() == "")

func _run_action() -> void:
	OS.shell_show_in_file_manager(Global.get_file_path())
