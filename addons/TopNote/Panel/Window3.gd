@tool
extends Window

var source

func _on_close_requested():
	source.get_child(0).text = get_child(0).get_child(0).text
	source.code = get_child(0).get_child(1).text
	hide()
	child_exiting_tree.emit(self)
