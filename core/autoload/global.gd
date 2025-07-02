extends Node
class_name GlobalAccess

## Global access way to all parts of Text Forge
## 
## You can access to this class using [code]Global[/code] autoload

## Returns currently opened file path
func get_file_path() -> String:
	return get_core().file_label.tooltip_text

## Returns currently opened file name
func get_file_name() -> String:
	return get_core().file_label.text

## Sets [param path] as opened file path
## [br][b]Note:[/b] This action isn't loading!
func set_file_path(path: String) -> void:
	get_core().file_label.tooltip_text = path

## Sets [param file_name] as opened file name
func set_file_name(file_name: String) -> void:
	get_core().file_label.text = file_name

## Returns [Editor] node
## [br][b][color=red]Caution:[/color] Some actions on this node can make crash![/b]
func get_editor() -> Editor:
	return get_core().editor

## Returns current text in editor
func get_editor_text() -> String:
	return get_editor().text

## Sets [param text] to editor
## [br][b]Note:[/b] This action will move caret to start of editor, so set caret pos after this is recommended
func set_editor_text(text: String) -> void:
	get_editor().text = text

## Will disable the editor
func set_editor_disabled(disabled: bool) -> void:
	get_editor().editable = not disabled

## Returns [code]true[/code] if editor is disabled
func is_editor_disabled() -> bool:
	return not get_editor().editable

## Returns [Core] node
func get_core() -> Core:
	return get_node("/root/Main")

## Returs node in [Core] that keep action scripts
func get_scripts_node() -> Node:
	return get_core().scripts

## Returns [EditorAPI] node
func get_editor_api() -> EditorAPI:
	return get_editor().get_child(0)

## Return [PanelManager] note
func get_panel_manager() -> PanelManager:
	return get_core().panel_manager
