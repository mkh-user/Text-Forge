extends Node
class_name SettingsAPI

const SETTINGS_FILE := "user://data.cfg"

func get_setting(section: String, key: String, default: Variant = null) -> Variant:
	if not FileAccess.file_exists(SETTINGS_FILE):
		return default
	var config := ConfigFile.new()
	var err := config.load(SETTINGS_FILE)
	if err:
		Signals.editor_notification.emit(2, "Can't load settings file!", "Error code: " + str(err))
		return default
	return config.get_value(section, key, default)


func set_setting(section: String, key: String, value: Variant = null) -> void:
	var config = ConfigFile.new()
	if FileAccess.file_exists(SETTINGS_FILE):
		config.load(SETTINGS_FILE)
	config.set_value(section, key, value)
	var err = config.save(SETTINGS_FILE)
	if err:
		Signals.editor_notification.emit(2, "Can't save settings file!", "Error code: " + str(err))
