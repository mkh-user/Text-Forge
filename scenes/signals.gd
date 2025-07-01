extends Node
class_name SignalBus

## Signal bus accessable with [code]Signals[/code] autoload

@warning_ignore_start("unused_signal")

## Emits when a script run requested, it will send to all scripts and scripts will filter it by [param script_id]
signal run_script(script_id: int)
## Emits when a subscript run requested, it will send to all multi scripts
signal run_subscript(id: int, submenu: PopupMenu, rootmenu: String)
## Will send to all scripts to check current state with activation state for each script
signal check_options

## Standard way to send notifications between modules
signal notification(id: String, data: Array)

## Standard notifications from editor
## Type: 0 -> info/message, 1 -> warning, 2 -> error
signal editor_notification(type: int, title: String, text: String)

## Requests close file, close script should connect itself to this
signal close_file
## Requests open file, open script should connect itself to this
signal open_file(path: String)
## Requests create new file, new script should connect itself to this
signal new_file
## Requests saving changes, [param from] will send to savers and return here to emit [signal run_script] again
signal save_request(from: int)
## Emits when save request finished, signal bus will emit [signal run_script] with [param to] id
signal save_finished(to: int)

## Emits when user selects a caret (for multi caret edits that have caret selection support)
signal caret_selected(index: int)

## Emits when user selects a mode
signal mode_selected

## Requests updating for recent files, [method Core._update_recent_files] is basic connection
signal update_recent_files

@warning_ignore_restore("unused_signal")

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
	run_script.emit(Global.get_scripts_node().get_node("save").id)


func _resume_after_save(to: int) -> void:
	if to == -1: return
	await SLib.wait(0.5)
	Global.set_file_name(Global.get_file_name().replace("*", ""))
	run_script.emit(to)
