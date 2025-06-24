extends AppScript

func _ready() -> void:
	menu.set_item_disabled(menu.get_item_index(id), Global.get_file_path() == "")

func _run_action() -> void:
	DisplayServer.clipboard_set(main_window.get_file_label().tooltip_text)
