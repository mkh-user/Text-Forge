extends Node
class_name AppExtensionCore

## Run-time autoload for handle extensions and base class for other extension classes.
##
## [b]Note:[/b] Use this class functions with [code]ExtensionCore[/code] singleton.

var extensions: Dictionary

func add_ui_extension(information: Dictionary) -> UIExtension:
	var new_extension := UIExtension.new()
	new_extension._name = information.name
	new_extension._id = information.id
	new_extension._author = information.author
	new_extension._about = information.about
	new_extension._link = information.link
	new_extension._type = Extension.ExtensionType.UI_EXTENSION
	add_child(new_extension)
	return new_extension
