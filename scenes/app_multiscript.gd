extends Node
class_name AppMultiscript

var id: int
var menu: PopupMenu
var need_file: bool = false
var action_shortcut: Shortcut = Shortcut.new()

@onready var main_window: Control = Global.get_main_node()

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
	if event.ctrl_pressed:
		masks[0] = KEY_MASK_CTRL
	if event.alt_pressed:
		masks[1] = KEY_MASK_ALT
	if event.shift_pressed:
		masks[2] = KEY_MASK_SHIFT
	return masks[0] | masks[1] | masks[2]| event.keycode

func _shortcut_input(event: InputEvent) -> void:
	if action_shortcut.matches_event(event):
		menu.popup()
		menu.get_item_submenu_node(menu.get_item_index(id)).popup_centered()
		#menu.get_item_submenu_node(menu.get_item_index(id)).position = get_window().size/2 + get_window().position

func run(script_id: int, popup: PopupMenu, action_name: String) -> void:
	if name != action_name.to_snake_case(): return
	_run_action(script_id, popup)

@warning_ignore("unused_parameter")
func _run_action(script_id: int, popup: PopupMenu) -> void:
	pass
