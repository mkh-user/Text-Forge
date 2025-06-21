extends AppScript

func _run_action() -> void:
	Signals.open_file.emit(main_window.get_file_label().tooltip_text)
