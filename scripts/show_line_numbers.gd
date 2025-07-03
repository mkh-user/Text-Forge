extends ActionScript

func _ready() -> void:
	_load_shortcut()
	Global.get_editor().gutters_draw_line_numbers = Settings.get_setting("editor_ui", "show_line_numbers", true)
	menu.set_item_checked(menu.get_item_index(id), Global.get_editor().gutters_draw_line_numbers)

func _run_action() -> void:
	Settings.set_setting("editor_ui", "show_line_numbers", not Global.get_editor().gutters_draw_line_numbers)
	Global.get_editor().gutters_draw_line_numbers = not Global.get_editor().gutters_draw_line_numbers
