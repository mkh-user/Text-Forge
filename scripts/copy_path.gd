extends AppScript

func _run_action() -> void:
	DisplayServer.clipboard_set(main_window.get_file_label().tooltip_text)
