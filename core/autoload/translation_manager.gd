extends Node
class_name TextForgeTranslator

## Text Forge Translation and localization tool. (Global singleton: [code]TFT[/code])
##
## This class is an autoload ([code]TFT[/code]) for translation feature in Text Forge, based on
## Text Forge modularity we  haven't any translation database, so if translate module texts is
## Required, modules should hold thier translation csv files.
## [br][b]Note:[/b] This function will send notifications, but can't translate itself notifications
## because this action can make infinite loop, so notifications from this function will be english!

## Current language code, use [method set_language] instead to set it.
var language: String = "en"
## Language code for fallbacks, use [method set_language] instead to set it.
var fallback: String = "en"


func _ready() -> void:
	language = Settings.get_setting("languages", "main", "en")
	fallback = Settings.get_setting("languages", "fallback", "en")
	if FileAccess.file_exists("user://_translation.cfg"):
		DirAccess.remove_absolute("user://_translation.cfg")


## Stes [member language] and [member fallback] to [param language_code] and [param fallback_code].
func set_language(language_code: String = "en", fallback_code: String = "en") -> void:
	language = language_code
	fallback = fallback_code
	Settings.set_setting("languages", "main", language)
	Settings.set_setting("languages", "fallback", fallback)


## Returns translated text from a saved [b]csv[/b] file, possible exceptions:
## [br] - [param source_file] does not exist: [code]Can't load translation data[/code] error, returns [param key]
## [br] - [member language] does not exist but the [member fallback] is successful: [code]Translation fallback to %fallback%[/code] warning, returns translated key to fallback language
## [br] - [member language] and [member fallback] do not exist: [code]Invalid language code![/code] error, returns [param key]
## [br] - [param key] does not exist: [code]Invalid translation key![/code] error, returns [param key]
func get_text(key: String, source_file: String) -> String:
	if key == "": return ""
	if not FileAccess.file_exists(source_file):
		Signals.notification.emit(2, "Can't load translation data", "File {0} doesn't exitsts!".format([source_file]))
		return key
	var file := FileAccess.open(source_file, FileAccess.READ)
	var column_names := file.get_csv_line()
	var lang
	if not column_names.has(language):
		if not column_names.has(fallback):
			Signals.notification.emit(2, "Invalid language code!", "Language {0} doesn't exitst in {1}, usign fallback language ({2}) failed.".format([language, source_file, fallback]))
			file.close()
			return key
		else:
			Signals.notification.emit(1, "Translation fallback to {0}".format([fallback]), "Can't find language {0} in translation source: {1}, using fallback language".format([language, source_file]))
			lang = fallback
	else:
		lang = language
	var index = column_names.find(lang)
	while file.get_position() < file.get_length():
		var line = file.get_csv_line()
		if line[0] == key:
			file.close()
			if line.size() == 1: return line[0]
			return line[index] if line.size() > index else line[1]
	Signals.notification.emit(2, "Invalid translation key!", "Can't find key \"{0}\" in translation source: {1}".format([key, source_file]))
	file.close()
	return key


## Returns translated [param key] from [param source] string csv.
## [br][b]Note:[/b] This function will save [param source] in [code]user://_translation.cfg[/code]
## and call [method get_text] for it, so if there is any bug you will see [code]user://_translation.cfg[/code] as source file.
func get_text_from_string_source(key: String, source: String) -> String:
	var file = FileAccess.open("user://_translation.cfg", FileAccess.WRITE)
	file.store_string(source)
	file.close()
	return get_text(key, "user://_translation.cfg")
