extends AppMultiscript

func _run_action(item_id, popup) -> void:
	if Global.get_file_name().ends_with("*"):
		SLib.send_alert("You have unsaved changes in currently opened file, please save them or use \"Close\" option before open recent files.
(Auto save request for recent files isn't available now)", "Text Forge - Alert")
		return
	Signals.open_file.emit(popup.get_item_text(popup.get_item_index(item_id)))
