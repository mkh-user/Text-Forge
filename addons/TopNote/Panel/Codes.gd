@tool
extends Panel

@onready var editor: CodeEdit = get_parent().get_parent().get_parent().get_parent().get_parent().get_child(4)

@export var code: String = ""


func _on_button_pressed():
	DisplayServer.clipboard_set(code)


func _on_button_2_pressed():
	editor.get_parent().show()
	editor.text = code


func _on_button_3_pressed():
	get_parent().remove_child(self)
