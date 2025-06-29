extends AppScript

var popup

func _run_action() -> void:
	popup = preload("res://scripts/script_scenes/go_to_line.tscn").instantiate()
	popup.popup_hide.connect(_go_to_line)
	add_child(popup)
	popup.show()
	popup.get_child(0).get_child(0).get_child(0).grab_focus()

func _go_to_line() -> void:
	var line: String = popup.get_child(0).get_child(0).get_child(0).get("text")
	popup.queue_free()
	var line_int: int = min(max(int(line) - 1, 0), Global.get_editor().get_line_count() - 1) if line.is_valid_int() else 0
	Global.get_editor().select(line_int, Global.get_editor().get_line(line_int).length(), line_int, Global.get_editor().get_line(line_int).length())
	Global.get_editor().center_viewport_to_caret()
	Global.get_editor().grab_focus()
