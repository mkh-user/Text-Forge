extends ActionScript

var dialog: ConfirmationDialog

func _ready() -> void:
	need_file = true
	_load_shortcut()

func _run_action() -> void:
	if Global.get_file_name().ends_with("*"):
		Signals.save_request.emit(id)
		return
	print("here")
	dialog = preload("res://scripts/script_scenes/secure_delete_dialog.tscn").instantiate()
	dialog.confirmed.connect(_secure_delete)
	add_child(dialog)
	dialog.show()

func _secure_delete() -> void:
	dialog.queue_free()
	var clear_buffer: Array
	for i in range(FileAccess.get_file_as_bytes(Global.get_file_path()).size()):
		clear_buffer.append(0)
	var file = FileAccess.open(Global.get_file_path(), FileAccess.WRITE)
	file.store_buffer(PackedByteArray(clear_buffer))
	file.close()
	DirAccess.remove_absolute(SLib.globalize_path(Global.get_file_path()))
	Signals.close_file.emit()
