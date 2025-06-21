extends Node
class_name AppScript

var id: int
var menu: PopupMenu
@onready var main_window: Control = get_node("/root/Main")

func run(script_id: int) -> void:
	if id != script_id: return
	_run_action()

func _run_action() -> void:
	pass
