extends Node
class_name AppScript

var id: int
var menu: PopupMenu
var action_shortcut: Shortcut = Shortcut.new()

@onready var main_window: Control = Global.get_main_node()

func _ready() -> void:
	pass

func _load_shortcut() -> void:
	if FileAccess.file_exists("res://shortcuts/{0}.tres".format([name])):
		action_shortcut = load("res://shortcuts/{0}.tres".format([name]))
		menu.set_item_accelerator(menu.get_item_index(id), _convert_event_to_key(action_shortcut.events[0]))

func _convert_event_to_key(event: InputEventKey) -> int:
	var masks = [0, 0, 0]
	if event.ctrl_pressed:
		masks[0] = KEY_MASK_CTRL
	if event.alt_pressed:
		masks[1] = KEY_MASK_ALT
	if event.shift_pressed:
		masks[2] = KEY_MASK_SHIFT
	return masks[0] | masks[1] | masks[2]| event.keycode

func run(script_id: int) -> void:
	if id != script_id: return
	_run_action()

func _run_action() -> void:
	pass
