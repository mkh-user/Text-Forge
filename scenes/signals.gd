extends Node

signal script_run(script_id)
signal close_file
signal open_file(path)
signal save_request(from)
signal save_finished(to)
signal run_subscript(id, submenu, rootmenu)
signal check_options
signal mode_selected(index)
signal caret_selected(index)
signal new_file

func _ready() -> void:
	save_request.connect(_handle_save_request)
	save_finished.connect(_resume_after_save)


func _handle_save_request(from: int) -> void:
	var save_popup: ConfirmationDialog = preload("res://scenes/popups/save_changes_dialog.tscn").instantiate()
	save_popup.confirmed.connect(_save_changes.bind(from))
	save_popup.canceled.connect(_resume_after_save.bind(from))
	save_popup.confirmed.connect(save_popup.queue_free)
	save_popup.canceled.connect(save_popup.queue_free)
	save_popup.show()
	add_child(save_popup)


func _save_changes(from: int) -> void:
	Global.get_scripts_node().get_node("save").callback = from
	script_run.emit(Global.get_scripts_node().get_node("save").id)


func _resume_after_save(to: int) -> void:
	if to == -1: return
	await SLib.wait(0.5)
	Global.set_file_name(Global.get_file_name().replace("*", ""))
	script_run.emit(to)
