extends AppScript

func _ready() -> void:
	_load_shortcut()
	menu.set_item_disabled(menu.get_item_index(id), Global.get_file_path() == "")

func _run_action() -> void:
	if Global.get_file_name().ends_with("*"):
		Signals.save_request.emit(id)
		return
	var clear_buffer: Array
	for i in range(FileAccess.get_file_as_bytes(Global.get_file_path()).size()):
		clear_buffer.append(0)
	var file = FileAccess.open(Global.get_file_path(), FileAccess.WRITE)
	file.store_buffer(PackedByteArray(clear_buffer))
	file.close()
	DirAccess.remove_absolute(SLib.globalize_path(Global.get_file_path()))
	Signals.close_file.emit()
