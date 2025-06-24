extends Node
class_name AppScript

var id: int
var menu: PopupMenu

@onready var main_window: Control = Global.get_main_node()

func _ready() -> void:
	pass

func run(script_id: int) -> void:
	if id != script_id: return
	_run_action()

func _run_action() -> void:
	pass
