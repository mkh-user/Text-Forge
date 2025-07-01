extends Control

@export var options: Container
@export var notifications: Container

var index: int

func _ready() -> void:
	Signals.editor_notification.connect(_editor_notification)


func _editor_notification(type: int, title: String, text: String) -> void:
	var notification_panel: NotificationPanel = ResourceLoader.load("res://data/panels/notifications/notification.tscn").instantiate()
	notifications.add_child(notification_panel)
	notifications.move_child(notification_panel, 0)
	match type:
		0: # info/message
			notification_panel.icon.text = "ℹ️"
		1: # warning
			notification_panel.icon.text = "⚠️"
		2: # error
			notification_panel.icon.text = "❌"
	notification_panel.title.text = title
	if text == "":
		notification_panel.text.hide()
	else:
		notification_panel.text.text = text
	print(size)
	if get_parent().current_tab != index:
		Global.get_panel_manager().change_panel_icon(PanelManager.PANEL_RIGHT, index, ResourceLoader.load("res://data/panels/notifications/notification.png"))


func _on_item_rect_changed() -> void:
	if get_parent().current_tab == index:
		Global.get_panel_manager().change_panel_icon(PanelManager.PANEL_RIGHT, index, ResourceLoader.load("res://data/panels/notifications/icon.png"))


func _on_clear_pressed() -> void:
	SLib.free_all_children(notifications)
