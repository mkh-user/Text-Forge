extends ActionScript

func _ready() -> void:
	_load_shortcut()
	Global.get_editor().gutters_draw_breakpoints_gutter = Settings.get_setting("editor_ui", "show_breakpoints", true)
	menu.set_item_checked(menu.get_item_index(id), Global.get_editor().gutters_draw_breakpoints_gutter)

func _run_action() -> void:
	Settings.set_setting("editor_ui", "show_breakpoints", not Global.get_editor().gutters_draw_breakpoints_gutter)
	Global.get_editor().gutters_draw_breakpoints_gutter = not Global.get_editor().gutters_draw_breakpoints_gutter
