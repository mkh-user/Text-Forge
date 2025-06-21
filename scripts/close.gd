extends AppScript

func _run_action() -> void:
	main_window.get_file_label().text = "There is no opened file"
	main_window.get_file_label().tooltip_text = ""
	main_window.get_editor().text = ""
	main_window.get_editor().editable = false
