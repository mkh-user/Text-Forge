extends Control
class_name EditorAPI

## Editor API and Mode Manager

## Modes folder
const MODES_FOLDER := "res://modes/"

## List of all modes
var modes: Array = []
## Selected mode
var selected_mode_index: int
## Currently is use mode
var current_mode: Dictionary


func _ready() -> void:
	Global.get_editor().add_comment_delimiter("#", "", true)
	Signals.mode_selected.connect(func(index): selected_mode_index = index - 1)
	_load_modes()


## Will send auto format command to correct mode
func auto_format(path: String) -> void:
	if path == "Unsaved":
		Signals.editor_notification.emit(2, "Please save file before auto formatting", "")
		return
	var available_modes := _get_available_modes(path.get_extension())
	if available_modes.size() == 0:
		SLib.send_alert("Can't find any mode for auto format this file!")
		current_mode = {}
		return
	if current_mode in available_modes:
		_auto_format(current_mode.script)
	elif available_modes.size() == 1:
		_auto_format(available_modes[0].script)
	else:
		var select_menu := PopupMenu.new()
		select_menu.add_separator("Select a mode to auto format")
		for mode in available_modes:
			select_menu.add_item(mode.name)
		select_menu.index_pressed.connect(func(index): Signals.mode_selected.emit(index))
		add_child(select_menu)
		select_menu.size = Vector2(400, 0)
		select_menu.popup_centered()
		await Signals.mode_selected
		select_menu.queue_free()
		_auto_format(available_modes[selected_mode_index].script)


func _auto_format(script: GDScript) -> void:
	script.new().auto_format()


## Will send save command to correct mode
func save_file(path: String) -> void:
	var available_modes := _get_available_modes(path.get_extension())
	if available_modes.size() == 0:
		SLib.send_alert("Can't find any mode to save this file, save file using UTF-8...")
		current_mode = {}
		var file = FileAccess.open(path, FileAccess.WRITE)
		file.store_string(Global.get_editor_text())
		file.close()
		return
	if current_mode in available_modes:
		_save_file(current_mode.script, path)
	elif available_modes.size() == 1:
		_save_file(available_modes[0].script, path)
	else:
		var select_menu := PopupMenu.new()
		select_menu.add_separator("Select a mode to save file")
		for mode in available_modes:
			select_menu.add_item(mode.name)
		select_menu.index_pressed.connect(func(index): Signals.mode_selected.emit(index))
		add_child(select_menu)
		select_menu.size = Vector2(400, 0)
		select_menu.popup_centered()
		await Signals.mode_selected
		select_menu.queue_free()
		_save_file(available_modes[selected_mode_index].script, path)


## Will send load command to correct mode
func load_file(path: String) -> void:
	var available_modes := _get_available_modes(path.get_extension())
	if available_modes.size() == 0:
		SLib.send_alert("Can't find any mode to open this file, loading file using UTF-8...")
		current_mode = {}
		var file = FileAccess.open(path, FileAccess.READ)
		Global.set_editor_disabled(false)
		Global.set_editor_text(file.get_as_text())
		file.close()
		return
	if available_modes.size() > 1:
		var select_menu := PopupMenu.new()
		select_menu.add_separator("Select a mode to open file")
		for mode in available_modes:
			select_menu.add_item(mode.name + " - " + mode.description)
		select_menu.index_pressed.connect(func(index): Signals.mode_selected.emit(index))
		add_child(select_menu)
		select_menu.size = Vector2(400, 0)
		select_menu.popup_centered()
		await Signals.mode_selected
		select_menu.queue_free()
	else:
		selected_mode_index = 0
	current_mode = available_modes[selected_mode_index]
	_load_highlighter(current_mode.highlighter)
	_load_file(current_mode.script, path)


func _save_file(saver: GDScript, path: String) -> void:
	saver.new().save_file(path)


func _load_file(loader: GDScript, path: String) -> void:
	Global.set_editor_text(loader.new().load_file(path))
	Global.set_editor_disabled(false)


func _load_highlighter(resource: Dictionary) -> void:
	var code_highlighter = CodeHighlighter.new()
	code_highlighter.number_color = resource.number_color
	code_highlighter.symbol_color = resource.symbol_color
	code_highlighter.function_color = resource.function_color
	code_highlighter.member_variable_color = resource.member_variable_color
	for color in resource.keyword_colors:
		for keyword in resource.keyword_colors[color]:
			code_highlighter.add_keyword_color(keyword, color)
	for color in resource.member_keyword_colors:
		for keyword in resource.member_keyword_colors[color]:
			code_highlighter.add_member_keyword_color(keyword, color)
	for color in resource.code_regions:
		code_highlighter.add_color_region(resource.code_regions[color][0], resource.code_regions[color][1], color, true if resource.code_regions[color][2] == "y" else false)
	get_parent().syntax_highlighter = code_highlighter


func _get_available_modes(extension: String) -> Array[Dictionary]:
	var available_modes: Array[Dictionary] = []
	for mode in modes:
		if extension in mode.extensions:
			available_modes.append(mode)
	return available_modes


func _load_modes() -> void:
	var mode_folders = DirAccess.get_directories_at(MODES_FOLDER)
	for mode_dir in mode_folders:
		if not FileAccess.file_exists(MODES_FOLDER.path_join(mode_dir).path_join("mode.cfg")): continue
		var mode: Dictionary = {}
		var config = ConfigFile.new()
		config.load(MODES_FOLDER.path_join(mode_dir).path_join("mode.cfg"))
		mode.name = config.get_value("mode", "name")
		mode.description = config.get_value("mode", "description")
		mode.author = config.get_value("mode", "author")
		mode.version = config.get_value("mode", "version")
		mode.extensions = config.get_value("mode", "extensions")
		mode.highlighter = {}
		for key in config.get_section_keys("highlighter"):
			mode.highlighter[key] = config.get_value("highlighter", key)
		mode.script = load(MODES_FOLDER.path_join(mode_dir).path_join("mode.gd"))
		modes.append(mode)
