extends HBoxContainer
class_name PanelManager

@export var tab_left: ItemList
@export var tab_right: ItemList
@export var tab_bottom: ItemList

@export var spliter_left: HSplitContainer
@export var spliter_right: HSplitContainer
@export var spliter_bottom: VSplitContainer

@export var panel_left: TabContainer
@export var panel_right: TabContainer
@export var panel_bottom: TabContainer

enum {
	PANEL_LEFT,
	PANEL_RIGHT,
	PANEL_BOTTOM
}

var panels := {
	PANEL_LEFT: {"size": 200, "closed": true, "panels": {}, "last_tab": 0},
	PANEL_RIGHT: {"size": 200, "closed": true, "panels": {}, "last_tab": 0},
	PANEL_BOTTOM: {"size": 200, "closed": true, "panels": {}, "last_tab": 0},
}

func _ready() -> void:
	spliter_left.item_rect_changed.connect(_apply_split)
	spliter_right.item_rect_changed.connect(_apply_split)
	spliter_bottom.item_rect_changed.connect(_apply_split)
	spliter_left.dragged.connect(func(offset):
		panels[PANEL_LEFT].size = offset
		panels[PANEL_LEFT].closed = offset == 0
		_apply_split()
	)
	spliter_right.dragged.connect(func(offset):
		panels[PANEL_RIGHT].size = spliter_right.size.x - offset
		panels[PANEL_RIGHT].closed = offset + 10 >= spliter_right.size.x
		_apply_split()
	)
	spliter_bottom.dragged.connect(func(offset):
		panels[PANEL_BOTTOM].size = spliter_bottom.size.y - offset
		panels[PANEL_BOTTOM].closed = offset + 10 >= spliter_bottom.size.y
		_apply_split()
	)
	tab_left.item_selected.connect(_handle_panel.bind(PANEL_LEFT))
	tab_right.item_selected.connect(_handle_panel.bind(PANEL_RIGHT))
	tab_bottom.item_selected.connect(_handle_panel.bind(PANEL_BOTTOM))
	panel_left.tab_selected.connect(func(tab): if tab != -1: panels[PANEL_LEFT]["last_tab"] = tab)
	panel_right.tab_selected.connect(func(tab): if tab != -1: panels[PANEL_RIGHT]["last_tab"] = tab)
	panel_bottom.tab_selected.connect(func(tab): if tab != -1: panels[PANEL_BOTTOM]["last_tab"] = tab)
	_load_panels()


func _load_panels() -> void:
	for panel in DirAccess.get_directories_at("res://data/panels"):
		var config = ConfigFile.new()
		config.load("res://data/panels/{0}/panel.cfg".format([panel]))
		var place = config.get_value("panel", "place")
		var converted: int
		if place == "R":
			converted = PANEL_RIGHT
		elif place == "B":
			converted = PANEL_BOTTOM
		else: # Also panels with invalid place
			converted = PANEL_LEFT
		_add_panel(converted, ResourceLoader.load("res://data/panels/{0}/panel.tscn".format([panel])).instantiate(), ResourceLoader.load("res://data/panels/{0}/icon.png".format([panel])))


func _handle_panel(selected: int, panel_id: int) -> void:
	var current_panel
	match panel_id:
		PANEL_LEFT:
			current_panel = panel_left
		PANEL_RIGHT:
			current_panel = panel_right
		PANEL_BOTTOM:
			current_panel = panel_bottom
	if current_panel.current_tab == selected and panels[panel_id].closed == false:
		panels[panel_id].closed = true
		_apply_split()
		return
	current_panel.current_tab = selected
	if panels[panel_id].closed == true:
		panels[panel_id].closed = false
		if panels[panel_id].size <= 10: panels[panel_id].size = 200
		_apply_split()


func _apply_split() -> void:
	print(panel_left.get_child(panel_left.current_tab).custom_minimum_size.x if panel_left.get_child_count() else 0)
	#print(max(panels[PANEL_LEFT].size, panel_left.get_child(panel_left.current_tab).custom_minimum_size.x if panel_left.get_child_count() else 0))
	spliter_left.split_offset = max(panels[PANEL_LEFT].size, panel_left.get_child(panel_left.current_tab).custom_minimum_size.x if panel_left.get_child_count() else 0)
	if panels[PANEL_LEFT].closed or panel_left.get_child_count() == 0:
		spliter_left.split_offset = 0
		panel_left.current_tab = -1
	else:
		panel_left.current_tab = panels[PANEL_LEFT]["last_tab"]
	spliter_right.split_offset = max(spliter_right.size.x - panels[PANEL_RIGHT].size, panel_right.get_child(panel_right.current_tab).custom_minimum_size.x if panel_right.get_child_count() else 0)
	if panels[PANEL_RIGHT].closed or panel_right.get_child_count() == 0:
		spliter_right.split_offset = spliter_right.size.x
		panel_right.current_tab = -1
	else:
		panel_right.current_tab = panels[PANEL_RIGHT]["last_tab"]
	spliter_bottom.split_offset = max(spliter_bottom.size.y - panels[PANEL_BOTTOM].size, panel_bottom.get_child(panel_bottom.current_tab).custom_minimum_size.y if panel_bottom.get_child_count() else 0)
	if panels[PANEL_BOTTOM].closed or panel_bottom.get_child_count() == 0:
		spliter_bottom.split_offset = spliter_bottom.size.y
		panel_bottom.current_tab = -1
	else:
		panel_bottom.current_tab = panels[PANEL_BOTTOM]["last_tab"]
		


func _add_panel(location: int, panel: Control, icon: Texture2D) -> void:
	var current_tab
	var current_panel
	match location:
		PANEL_LEFT:
			current_tab = tab_left
			current_panel = panel_left
		PANEL_RIGHT:
			current_tab = tab_right
			current_panel = panel_right
		PANEL_BOTTOM:
			current_tab = tab_bottom
			current_panel = panel_bottom
	var index
	index = current_tab.add_icon_item(icon)
	if index != current_panel.get_child_count():
		current_tab.remove_item(index)
		push_error("There is a bug in left panel")
		return
	current_panel.add_child(panel)
	panels[location].panels[index] = panel


func change_panel_icon(location, index, icon: Texture2D) -> void:
	var current_tab: ItemList
	match location:
		PANEL_LEFT:
			current_tab = tab_left
		PANEL_RIGHT:
			current_tab = tab_right
		PANEL_BOTTOM:
			current_tab = tab_bottom
	current_tab.set_item_icon(index, icon)
