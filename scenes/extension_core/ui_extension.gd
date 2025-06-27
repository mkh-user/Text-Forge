extends Extension
class_name UIExtension

## Base class for work with UI for extensions

## Returns main window root node.
func get_main_window() -> Core:
	return ExtensionCore.get_node("/root/Main")

## Returns background [ColorRect] in main window.
func get_background_color_rect() -> ColorRect:
	return SLib.find_child_of_class(get_main_window(), "ColorRect")
