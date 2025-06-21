extends AppScript

func _run_action() -> void:
	OS.shell_show_in_file_manager(main_window.get_file_label().tooltip_text)
