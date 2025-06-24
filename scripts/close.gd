extends AppScript


func _ready() -> void:
	menu.set_item_disabled(menu.get_item_index(id), Global.get_file_path() == "")

func _run_action() -> void:
	if Global.get_file_name().ends_with("*"):
		Signals.save_request.emit(id)
		return
	Global.set_file_name("There is no opened file")
	Global.set_file_path("")
	Global.set_editor_text("")
	Global.set_editor_disabled(true)
	Signals.check_options.emit()
