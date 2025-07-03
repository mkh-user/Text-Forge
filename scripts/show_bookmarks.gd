extends ActionScript

func _ready() -> void:
	_load_shortcut()
	Global.get_editor().gutters_draw_bookmarks = Settings.get_setting("editor_ui", "show_bookmarks", true)
	menu.set_item_checked(menu.get_item_index(id), Global.get_editor().gutters_draw_bookmarks)

func _run_action() -> void:
	Settings.set_setting("editor_ui", "show_bookmarks", not Global.get_editor().gutters_draw_bookmarks)
	Global.get_editor().gutters_draw_bookmarks = not Global.get_editor().gutters_draw_bookmarks
