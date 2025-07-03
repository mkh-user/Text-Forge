extends ActionScript

func _ready() -> void:
	_load_shortcut()
	Global.get_editor().add_theme_font_size_override("font_size", Settings.get_setting("editor_ui", "font_size", 16))

func _run_action() -> void:
	Global.get_editor().add_theme_font_size_override("font_size", Settings.get_setting("editor_ui", "base_font_size", 16))
	Settings.set_setting("editor_ui", "font_size", Settings.get_setting("editor_ui", "base_font_size", 16))
