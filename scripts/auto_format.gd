extends ActionScript

func _run_action() -> void:
	Global.get_editor_api().auto_format(Global.get_file_path())
	Global.get_editor().text_changed.emit()
