@tool
extends CheckBox

@export var type = 0

func _on_pressed():
	var RemoveMode = self.get_parent().get_parent().get_parent().get_child(1).get_child(2)
	if not RemoveMode.button_pressed: return
	self.button_pressed = true
	self.child_entered_tree.emit(self)
