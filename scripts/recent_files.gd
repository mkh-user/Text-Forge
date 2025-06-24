extends AppMultiscript

func _ready() -> void:
	_load_shortcut()

func _run_action(item_id, popup) -> void:
	if Global.get_file_name().ends_with("*"):
		SLib.send_alert("You will recive an alert for close currently opened file, please run this action again after save or discard your changes.
(Auto save request for recent files isn't available now)", "Text Forge - Alert")
		Signals.close_file.emit()
		return
	Signals.open_file.emit(popup.get_item_text(popup.get_item_index(item_id)))
