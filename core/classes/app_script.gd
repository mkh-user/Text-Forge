extends Node
class_name ActionScript

var id: int
var menu: PopupMenu
var need_file: bool = false
var action_shortcut := InputEventKey.new()

func _ready() -> void:
	_load_shortcut()

func _check_option() -> void:
	if need_file:
		menu.set_item_disabled(menu.get_item_index(id), Global.get_file_path() == "")

func _load_shortcut() -> void:
	if FileAccess.file_exists("res://shortcuts/{0}.tres".format([name])):
		action_shortcut = load("res://shortcuts/{0}.tres".format([name])).events[0]
		menu.set_item_accelerator(menu.get_item_index(id), _convert_event_to_key(action_shortcut))

func _convert_event_to_key(event: InputEventKey) -> int:
	return (KEY_MASK_CTRL if event.ctrl_pressed else 0) | (KEY_MASK_ALT if event.alt_pressed else 0) | (KEY_MASK_SHIFT if event.shift_pressed else 0) | event.keycode

func run(script_id: int) -> void:
	if id != script_id: return
	_run_action()

func _run_action() -> void:
	pass
