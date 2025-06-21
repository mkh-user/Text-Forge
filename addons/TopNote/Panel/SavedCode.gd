@tool
extends VBoxContainer

@onready var editor: CodeEdit

@export var code: String = ""


func _on_button_pressed():
	DisplayServer.clipboard_set(code)


func _on_button_2_pressed():
	editor = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_child(4).get_child(0).get_child(1)
	editor.get_parent().get_child(0).text = get_child(0).text
	editor.get_parent().get_parent().source = self
	editor.get_parent().get_parent().show()
	editor.text = code


func _on_button_3_pressed():
	get_parent().remove_child(self)
