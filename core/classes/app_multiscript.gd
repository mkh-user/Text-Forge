extends Node
class_name MultiActionScript

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

func _shortcut_input(event: InputEvent) -> void:
	if action_shortcut.matches_event(event):
		menu.popup()
		menu.get_item_submenu_node(menu.get_item_index(id)).popup_centered()

func run(script_id: int, popup: PopupMenu, action_name: String) -> void:
	if name != action_name.to_snake_case(): return
	_run_action(script_id, popup)

func _run_action(script_id: int, popup: PopupMenu) -> void:
	pass
