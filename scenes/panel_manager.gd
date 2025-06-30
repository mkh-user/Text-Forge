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
	PANEL_LEFT: {"size": 200, "closed": true, "panels": {}},
	PANEL_RIGHT: {"size": 200, "closed": true, "panels": {}},
	PANEL_BOTTOM: {"size": 200, "closed": true, "panels": {}},
}

func _ready() -> void:
	spliter_left.item_rect_changed.connect(_apply_split)
	spliter_right.item_rect_changed.connect(_apply_split)
	spliter_bottom.item_rect_changed.connect(_apply_split)
	spliter_left.dragged.connect(func(offset):
		panels[PANEL_LEFT].size = offset
		panels[PANEL_LEFT].closed = offset == 0
	)
	spliter_right.dragged.connect(func(offset):
		panels[PANEL_RIGHT].size = spliter_right.size.x - offset
		panels[PANEL_RIGHT].closed = offset == spliter_right.size.x
	)
	spliter_bottom.dragged.connect(func(offset):
		panels[PANEL_BOTTOM].size = spliter_bottom.size.y - offset
		panels[PANEL_BOTTOM].closed = offset == spliter_bottom.size.y
	)
	tab_right.item_selected.connect(_handle_right_panel)


func _handle_right_panel(selected: int) -> void:
	if panel_right.current_tab == selected and panels[PANEL_RIGHT].closed == false:
		panels[PANEL_RIGHT].closed = true
		_apply_split()
		return
	panel_right.current_tab = selected
	if panels[PANEL_RIGHT].closed == true:
		panels[PANEL_RIGHT].closed = false
		if panels[PANEL_RIGHT].size == 0: panels[PANEL_RIGHT].size = 200
		_apply_split()


func _apply_split() -> void:
	spliter_left.split_offset = panels[PANEL_LEFT].size
	if panels[PANEL_LEFT].closed: spliter_left.split_offset = 0
	spliter_right.split_offset = spliter_right.size.x - panels[PANEL_RIGHT].size
	if panels[PANEL_RIGHT].closed: spliter_right.split_offset = spliter_right.size.x
	spliter_bottom.split_offset = spliter_bottom.size.y - panels[PANEL_BOTTOM].size
	if panels[PANEL_BOTTOM].closed: spliter_bottom.split_offset = spliter_bottom.size.y


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
	panels[location].panels.index = panel
