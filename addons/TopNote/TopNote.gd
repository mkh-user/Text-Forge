@tool
extends EditorPlugin
class_name TopNote

const PLACE = "res://addons/TopNote/settings.txt"


const DEFAULT = PLACE_BOTTOM


enum {
	PLACE_BOTTOM,
	PLACE_TOOLBAR,
	PLACE_SPATIAL_EDITOR_MENU,
	PLACE_SPATIAL_EDITOR_SIDE_LEFT,
	PLACE_SPATIAL_EDITOR_SIDE_RIGHT,
	PLACE_SPATIAL_EDITOR_BOTTOM,
	PLACE_CANVAS_EDITOR_MENU,
	PLACE_CANVAS_EDITOR_SIDE_LEFT,
	PLACE_CANVAS_EDITOR_SIDE_RIGHT,
	PLACE_CANVAS_EDITOR_BOTTOM,
	PLACE_INSPECTOR,
	PLACE_SLOT_LEFT_UL,
	PLACE_SLOT_LEFT_BL,
	PLACE_SLOT_LEFT_UR,
	PLACE_SLOT_LEFT_BR,
	PLACE_SLOT_RIGHT_UL,
	PLACE_SLOT_RIGHT_BL,
	PLACE_SLOT_RIGHT_UR,
	PLACE_SLOT_RIGHT_BR,
}


var place: int
var panel: Control
var button: Button
var popup: Window
var move_list: ItemList

func _enter_tree():
	_load_place()
	panel = preload("res://addons/TopNote/Panel/Panel.tscn").instantiate()
	button = preload("res://addons/TopNote/Panel/Button.tscn").instantiate()
	popup = preload("res://addons/TopNote/Panel/Popup.tscn").instantiate()
	move_list = panel.get_child(1).get_child(0)
	if not move_list.item_selected.is_connected(self._move_to):
		move_list.item_selected.connect(self._move_to)
	if place in [PLACE_TOOLBAR, PLACE_SPATIAL_EDITOR_MENU]:
		popup.add_child(panel)
	match place:
		PLACE_BOTTOM:
			add_control_to_bottom_panel(panel, "Top Note")
			make_bottom_panel_item_visible(panel)
		PLACE_TOOLBAR:
			EditorInterface.get_base_control().add_child(popup)
			add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, button)
			button.pressed.connect(self._show_popup)
		PLACE_SPATIAL_EDITOR_MENU:
			EditorInterface.get_base_control().add_child(popup)
			add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, button)
			button.flat = true
			button.pressed.connect(self._show_popup)
		PLACE_SPATIAL_EDITOR_SIDE_LEFT:
			add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_SIDE_LEFT, panel)
		PLACE_SPATIAL_EDITOR_SIDE_RIGHT:
			add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_SIDE_RIGHT, panel)
		PLACE_SPATIAL_EDITOR_BOTTOM:
			add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_BOTTOM, panel)
		PLACE_CANVAS_EDITOR_MENU:
			EditorInterface.get_base_control().add_child(popup)
			add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, button)
			button.flat = true
			button.pressed.connect(self._show_popup)
		PLACE_CANVAS_EDITOR_SIDE_LEFT:
			add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_SIDE_LEFT, panel)
		PLACE_CANVAS_EDITOR_SIDE_RIGHT:
			add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_SIDE_RIGHT, panel)
		PLACE_CANVAS_EDITOR_BOTTOM:
			add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_BOTTOM, panel)
		PLACE_INSPECTOR:
			add_control_to_container(EditorPlugin.CONTAINER_INSPECTOR_BOTTOM, panel)
		PLACE_SLOT_LEFT_UL:
			add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UL, panel)
		PLACE_SLOT_LEFT_BL:
			add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_BL, panel)
		PLACE_SLOT_LEFT_UR:
			add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UR, panel)
		PLACE_SLOT_LEFT_BR:
			add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_BR, panel)
		PLACE_SLOT_RIGHT_UL:
			add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_UL, panel)
		PLACE_SLOT_RIGHT_BL:
			add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_BL, panel)
		PLACE_SLOT_RIGHT_UR:
			add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_UR, panel)
		PLACE_SLOT_RIGHT_BR:
			add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_BR, panel)


func _exit_tree():
	move_list.item_selected.disconnect(self._move_to)
	match place:
		PLACE_BOTTOM:
			remove_control_from_bottom_panel(panel)
		PLACE_TOOLBAR:
			remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, button)
			EditorInterface.get_base_control().remove_child(popup)
			button.pressed.disconnect(self._show_popup)
		PLACE_SPATIAL_EDITOR_MENU:
			remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, button)
			EditorInterface.get_base_control().remove_child(popup)
			button.pressed.disconnect(self._show_popup)
		PLACE_SPATIAL_EDITOR_SIDE_LEFT:
			remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_SIDE_LEFT, panel)
		PLACE_SPATIAL_EDITOR_SIDE_RIGHT:
			remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_SIDE_RIGHT, panel)
		PLACE_SPATIAL_EDITOR_BOTTOM:
			remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_BOTTOM, panel)
		PLACE_CANVAS_EDITOR_MENU:
			EditorInterface.get_base_control().remove_child(popup)
			remove_control_from_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, button)
			button.pressed.disconnect(self._show_popup)
		PLACE_CANVAS_EDITOR_SIDE_LEFT:
			remove_control_from_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_SIDE_LEFT, panel)
		PLACE_CANVAS_EDITOR_SIDE_RIGHT:
			remove_control_from_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_SIDE_RIGHT, panel)
		PLACE_CANVAS_EDITOR_BOTTOM:
			remove_control_from_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_BOTTOM, panel)
		PLACE_INSPECTOR:
			remove_control_from_container(EditorPlugin.CONTAINER_INSPECTOR_BOTTOM, panel)
		_:
			remove_control_from_docks(panel)

func _move_to(index):
	if place in [PLACE_TOOLBAR, PLACE_SPATIAL_EDITOR_MENU]:
		popup.hide()
	var file = FileAccess.open(PLACE, FileAccess.WRITE)
	file.store_string(str(index))
	file.close()
	_exit_tree()
	_enter_tree()


func _show_popup():
	popup.show()


func _load_place():
	if not FileAccess.file_exists(PLACE):
		place = DEFAULT
		return
	var file = FileAccess.open(PLACE, FileAccess.READ)
	place = int(file.get_as_text())
	file.close()
	if place == null:
		place = DEFAULT
		file = FileAccess.open(PLACE, FileAccess.WRITE)
		file.store_string(str(DEFAULT))
		file.close()


func _get_plugin_name():
	return "Top Note"

func _get_plugin_icon():
	return load("res://addons/TopNote/icon.svg")

func _handles(object: Object) -> bool:
	return object is Resource

func _edit(object: Object) -> void:
	if not is_instance_valid(panel): return
	if place in [PLACE_TOOLBAR, PLACE_CANVAS_EDITOR_MENU, PLACE_SPATIAL_EDITOR_MENU]: return
	if object is Resource and not object is Script:
		make_bottom_panel_item_visible(panel)
		panel.open_linked_note(object)
