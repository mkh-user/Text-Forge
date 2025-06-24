extends Control
class_name App_MainWindow

@export var menu_container: Container
@export var file_label: Label
@export var editor: CodeEdit
@export var scripts: Node

const MENU_BUTTON_SCENE := preload("res://scenes/menu/menu_button.tscn")
const EDIT_MODE_SCENE := preload("res://scenes/menu/edit_mode.tscn")
const MAIN_UI_DATA := "res://data/main_ui.ini"
const RECENT_FILES_DATA := "user://recent_files.txt"
const TEMPLATES_FOLDER := "user://templates/"

var edit_mode_node: OptionButton
var recent_files_submenu: PopupMenu

var main_menu_data: Dictionary

func _ready() -> void:
	UIExtension.new().get_main_window()
	_load_main_menu()
	_load_scripts()


func _load_scripts() -> void:
	for menu in main_menu_data:
		for item in main_menu_data[menu]:
			if not item.get("type", 0) in [0, 1, 2, 3]: continue
			if not FileAccess.file_exists("res://scripts/" + item.get("text", "").to_snake_case().replace(".", "") + ".gd"):
				if item.has("popup") and item.get("type", 0) != 1: item.get("popup").set_item_disabled(item.get("popup").get_item_index(item.get("code", 0)), true)
				continue
			var script = load("res://scripts/" + item.get("text", "").to_snake_case().replace(".", "") + ".gd").new()
			if item.get("type", 0) == 0:
				Signals.script_run.connect(script.run)
			elif item.get("type", 0) == 1:
				Signals.run_subscript.connect(script.run)
			Signals.check_options.connect(script._ready)
			script.id = item.get("code", -1)
			script.menu = item.get("popup")
			script.name = item.get("text", "").to_snake_case().replace(".", "")
			scripts.add_child(script)


func _load_main_menu() -> void:
	# load data
	var config := ConfigFile.new()
	config.load(MAIN_UI_DATA)
	
	# to keep new menu button for each loop
	var new_menu_button: MenuButton
	# new button name (text)
	var menu_name: String
	# for each button
	for menu_section: String in config.get_section_keys("main_menu"):
		# load data in main_menu_data
		main_menu_data[menu_section] = config.get_value("main_menu", menu_section)
	for menu_item: String in config.get_section_keys("main_menu"):
		if menu_item.ends_with("_submenu"): continue # skip next steps for submenu items
		
		menu_name = menu_item.erase(menu_item.rfind("_menu"), 5) # get menu name
		menu_name = menu_name.capitalize() # capitalize it
		
		new_menu_button = MENU_BUTTON_SCENE.instantiate() # create new menu button
		new_menu_button.text = menu_name
		
		# for each option in current menu
		for item: Dictionary in main_menu_data[menu_item]:
			main_menu_data[menu_item][main_menu_data[menu_item].find(item)]["popup"] = new_menu_button.get_popup()
			match item.get("type", 0):
				0: # original option
					new_menu_button.get_popup().add_item(item.get("text", ""), item.get("code", -1))
				1: # submenu
					var submenu := PopupMenu.new()
					match item.get("text", ""):
						"Recent Files": # needs special action
							recent_files_submenu = submenu
							if FileAccess.file_exists(RECENT_FILES_DATA):
								var file = FileAccess.open(RECENT_FILES_DATA, FileAccess.READ)
								var recent_files = file.get_as_text()
								file.close()
								for recent in SLib.merge_unique(recent_files.split("\n", false), []):
									if submenu.item_count == 15: break
									submenu.add_item(recent)
						"New With Template": # needs special action
							if not DirAccess.dir_exists_absolute(SLib.globalize_path(TEMPLATES_FOLDER)):
								DirAccess.make_dir_recursive_absolute(SLib.globalize_path(TEMPLATES_FOLDER))
							for recent in DirAccess.get_files_at(TEMPLATES_FOLDER):
								submenu.add_item(recent)
						"Extensions": # needs load from another script
							pass
						_: # just load items to another popup menu for other submenus
							for submenu_item: Dictionary in config.get_value("main_menu", item.get("text", "").to_snake_case() + "_submenu"):
								main_menu_data[item.get("text", "").to_snake_case() + "_submenu"][main_menu_data[item.get("text", "").to_snake_case() + "_submenu"].find(submenu_item)]["popup"] = submenu
								match submenu_item.get("type", 0):
									0: # original option
										submenu.add_item(submenu_item.get("text", ""), submenu_item.get("code", -1))
									-1: # seperator
										submenu.add_separator(submenu_item.get("text", ""))
					# connect submenu to handle state function
					submenu.id_pressed.connect(_handle_menu_option_state.bind(submenu, item.get("text", "")))
					# add submenu
					new_menu_button.get_popup().add_submenu_node_item(item.get("text", ""), submenu, item.get("code", -1))
					# disable empty submenus
					if submenu.item_count == 0:
						new_menu_button.get_popup().set_item_disabled(-1, true)
				-1: # seperator
					new_menu_button.get_popup().add_separator(item.get("text", ""))
				2: # checkable
					new_menu_button.get_popup().add_check_item(item.get("text", ""), item.get("code", -1))
				3: # radio
					new_menu_button.get_popup().add_radio_check_item(item.get("text", ""), item.get("code", -1))
		# connect menu to handle state function
		new_menu_button.get_popup().id_pressed.connect(_handle_menu_option_state.bind(new_menu_button.get_popup()))
		# add new menu
		menu_container.add_child(new_menu_button)
	# add edit mode button
	edit_mode_node = EDIT_MODE_SCENE.instantiate()
	menu_container.add_child(edit_mode_node)


func _handle_menu_option_state(id: int, menu: PopupMenu, rootmenu: String = "") -> void:
	var index = menu.get_item_index(id)
	# for checkable options
	if menu.is_item_checkable(index) and not menu.is_item_radio_checkable(index):
		menu.toggle_item_checked(index)
	# for radio checkable options
	if menu.is_item_radio_checkable(index) and not menu.is_item_checked(index): # ignore select currently selected option
		menu.toggle_item_checked(index) # toggle selected option state
		
		# search for related radio options and set them to unchecked
		var check_index = index - 1 # start first search from last option before selected option
		while true: # options before selected option
			if check_index < 0: break # break outside of valid options
			# break when touch an option that isn't radio checkbox
			if not menu.is_item_radio_checkable(check_index): break
			menu.set_item_checked(check_index, false) # set option unchecked
			check_index -= 1 # shift up
		check_index = index + 1 # start second search from first option after selected option
		while true: # options after selected option
			if check_index + 1 > menu.item_count: break # break outside of valid options
			# break when touch an option that isn't radio checkbox
			if not menu.is_item_radio_checkable(check_index): break
			menu.set_item_checked(check_index, false) # set option unchecked
			check_index += 1 # shift down
	
	if not rootmenu:
		Signals.script_run.emit(id)
	else:
		Signals.run_subscript.emit(id, menu, rootmenu)


func set_edit_mode(index: int) -> void:
	edit_mode_node.selected = index


func _on_code_edit_text_changed() -> void:
	if not file_label.text.ends_with("*"):
		file_label.text += "*"


func update_recent_files() -> void:
	recent_files_submenu.clear()
	if FileAccess.file_exists(RECENT_FILES_DATA):
		var file = FileAccess.open(RECENT_FILES_DATA, FileAccess.READ)
		var recent_files = file.get_as_text()
		file.close()
		for recent in SLib.merge_unique(recent_files.split("\n", false), []):
			if recent_files_submenu.item_count == 15: break
			recent_files_submenu.add_item(recent)
