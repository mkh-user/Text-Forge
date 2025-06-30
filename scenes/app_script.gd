extends Node
class_name ActionScript

var id: int
var menu: PopupMenu
var need_file: bool = false
var action_shortcut: Shortcut = Shortcut.new()

@onready var main_window: Core = Global.get_main_node()

func _ready() -> void:
	_load_shortcut()

func _check_option() -> void:
	if need_file:
		menu.set_item_disabled(menu.get_item_index(id), Global.get_file_path() == "")

func _load_shortcut() -> void:
	if FileAccess.file_exists("res://shortcuts/{0}.tres".format([name])):
		action_shortcut = load("res://shortcuts/{0}.tres".format([name]))
		menu.set_item_accelerator(menu.get_item_index(id), _convert_event_to_key(action_shortcut.events[0]))

func _convert_event_to_key(event: InputEventKey) -> int:
	var masks = [0, 0, 0]
	if event.ctrl_pressed and not event.command_or_control_autoremap:
		masks[0] = KEY_MASK_CTRL
	if event.command_or_control_autoremap:
		masks[0] = KEY_MASK_CMD_OR_CTRL
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
