extends AppScript

func _run_action() -> void:
	main_window.get_file_label().text = "New file"
	main_window.get_file_label().tooltip_text = "Unsaved"
	main_window.get_editor().editable = true
	main_window.get_editor().text = ""
