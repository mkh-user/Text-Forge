extends Node
class_name Extension

enum ExtensionType {
	UI_EXTENSION,
}

var _name: String
var _id: String
var _author: Array[String]
var _about: String
var _link: String
var _type: ExtensionType


func get_extension_name() -> String:
	return _name


func get_extension_id() -> String:
	return _id


func get_extension_author() -> Array[String]:
	return _author


func get_extension_about() -> String:
	return _about


func get_extension_link() -> String:
	return _link

func get_extesion_type() -> ExtensionType:
	return _type
