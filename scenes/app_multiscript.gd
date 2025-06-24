extends Node
class_name AppMultiscript

var id: int
var menu: PopupMenu

@onready var main_window: Control = Global.get_main_node()

func _ready() -> void:
	pass

func run(script_id: int, popup: PopupMenu, action_name: String) -> void:
	if name != action_name.to_snake_case(): return
	_run_action(script_id, popup)

@warning_ignore("unused_parameter")
func _run_action(script_id: int, popup: PopupMenu) -> void:
	pass
