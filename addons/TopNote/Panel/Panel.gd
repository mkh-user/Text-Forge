@tool
extends Control

enum {
	TODO_ADD_FEATURE,
	TODO_FIX_BUG,
	TODO_NONE,
}

const NOTES = "res://addons/TopNote/Files/Notes.txt"
const TODO = "res://addons/TopNote/Files/ToDo.txt"
const CODES = "res://addons/TopNote/Files/Codes.txt"
const LINKED = "res://addons/TopNote/Files/LinkedNotes.txt"

@onready var Tab: TabContainer = $VBox/Tab
@onready var Menu: MenuButton = $VBox/HBox/Menu
@onready var Notes: TextEdit = $VBox/Tab/Notes
@onready var Move_to: Window = $MoveTo
@onready var About: Window = $About
@onready var Todo_list: VBoxContainer = $VBox/Tab/ToDo/Scroll/VBox
@onready var Sample: CheckBox = $VBox/Tab/ToDo/Sample
@onready var NewTodo_Text: LineEdit = $VBox/Tab/ToDo/Add/Text
@onready var NewTodo_Type: OptionButton = $VBox/Tab/ToDo/Add/Type
@onready var Remove: ConfirmationDialog = $RemoveTodo
@onready var TodoSearch: LineEdit = $VBox/Tab/ToDo/Tools/Search
@onready var TodoFilter: OptionButton = $VBox/Tab/ToDo/Tools/Filter
@onready var CodeSample: VBoxContainer = $VBox/Tab/Codes/Sample
@onready var CodeSearch: LineEdit = $VBox/Tab/Codes/Find/Search
@onready var CodeFilter: OptionButton = $VBox/Tab/Codes/Find/Filter
@onready var NewCode_Name: LineEdit = $VBox/Tab/Codes/New/Name
@onready var Code_list: HFlowContainer = $VBox/Tab/Codes/Scroll/HFlow
@onready var Linked_Note: TextEdit = $"VBox/Tab/Linked Notes"

var Todo := []
var Codes := {}
var Links := {}

var rid = null

var file

func _ready():
	_initialize_menu()
	_load_notes()
	_load_todo()
	_load_code()
	_load_linked()


func _initialize_menu() -> void:
	var popup: PopupMenu = Menu.get_popup()
	popup.id_pressed.connect(self._show_menu)


func _load_linked():
	if not FileAccess.file_exists(LINKED): return
	file = FileAccess.open(LINKED, FileAccess.READ)
	var mix = file.get_as_text().split("|TN|")
	for link in mix:
		if link.split("|LN|").size() < 2: continue
		Links[link.split("|LN|")[0]] = link.split("|LN|")[1]


func _load_code(search: String = "", search_text: bool = false) -> void:
	if not FileAccess.file_exists(CODES): return
	file = FileAccess.open(CODES, FileAccess.READ)
	var code_mix = file.get_as_text().split("[TN Code - Name]")
	file.close()
	if code_mix.size() == 0: return
	var code_texts = []
	var code_names = []
	for code in code_mix:
		if code == "" or code.find("[TN Code - Text]") == 0: continue
		code_names.append(code.split("[TN Code - Text]")[0])
		code_texts.append(code.split("[TN Code - Text]")[1])
	Codes.clear()
	for code in range(code_names.size()):
		if search != "":
			match search_text:
				true:
					if code_texts[code].find(search) == -1 and code_names[code].find(search) == -1:
						print("T")
						continue
				false:
					if code_names[code].find(search) == -1:
						continue
						print("N")
		Codes[code_names[code]] = code_texts[code]
	if Codes.keys().size() == 0: return
	var sample: VBoxContainer
	for code in Codes:
		sample = CodeSample.duplicate()
		sample.get_child(0).text = code
		sample.code = Codes[code]
		sample.show()
		Code_list.add_child(sample)


func _load_todo(text: String = "", type: int = 0) -> void:
	if not FileAccess.file_exists(TODO): return
	file = FileAccess.open(TODO, FileAccess.READ)
	Todo = file.get_as_text().split("\n", false)
	file.close()
	if Todo.size() == 0: return
	var sample: CheckBox
	var list: Array
	for item in Todo:
		list = item.split("|TN|")
		if type != 0 and int(list[1]) + 1 != type: continue
		if text != "" and list[2].find(text) == -1: continue
		sample = Sample.duplicate()
		sample.button_pressed = bool(int(list[0]))
		match int(list[1]):
			TODO_ADD_FEATURE:
				sample.icon = load("res://addons/TopNote/Icons/Add.png")
			TODO_FIX_BUG:
				sample.icon = load("res://addons/TopNote/Icons/Fix.png")
			_:
				sample.icon = load("res://addons/TopNote/Icons/None.png")
		sample.type = int(list[1])
		sample.text = list[2]
		sample.show()
		Todo_list.add_child(sample)


func _show_menu(index: int) -> void:
	match index:
		0:
			Move_to.show()
		1:
			About.show()


func _load_notes() -> void:
	if not FileAccess.file_exists(NOTES):
		Notes.text = ""
		return
	file = FileAccess.open(NOTES, FileAccess.READ)
	Notes.text = file.get_as_text()
	file.close()


func _save_notes() -> void:
	file = FileAccess.open(NOTES, FileAccess.WRITE)
	file.store_string(Notes.text)
	file.close()


func _on_notes_text_changed() -> void:
	_save_notes()


func _on_window_close_requested() -> void:
	Move_to.hide()


func _on_window_2_close_requested() -> void:
	About.hide()


func _save_code() -> void:
	Codes.clear()
	for code in Code_list.get_children():
		Codes[code.get_child(0).text] = code.code
	file = FileAccess.open(CODES, FileAccess.WRITE)
	var text = ""
	var count = Codes.keys().size()
	for item in Codes.keys():
		text += "[TN Code - Name]" + item + "[TN Code - Text]" + Codes[item]
	file.store_string(text)
	file.close()


func _save_todo() -> void:
	Todo.clear()
	var data
	for item in Todo_list.get_children():
		data = [0, 0, ""]
		match item.button_pressed:
			true:
				data[0] = "1"
			false:
				data[0] = "0"
		data[1] = str(item.type)
		data[2] = str(item.text)
		Todo.append("{Do}|TN|{Type}|TN|{Text}".format({"Do": data[0], "Type": data[1], "Text": data[2]}))
	file = FileAccess.open(TODO, FileAccess.WRITE)
	var text = ""
	for item in Todo.size():
		text += Todo[item]
		if item + 1 != Todo.size():
			text += "\n"
	file.store_string(text)
	file.close()


func _on_button_pressed():
	while NewTodo_Text.text.begins_with(" "): NewTodo_Text.text = NewTodo_Text.text.erase(0)
	while NewTodo_Text.text.ends_with(" "): NewTodo_Text.text = NewTodo_Text.text.erase(NewTodo_Text.text.length() - 1)
	if NewTodo_Text.text == "": return
	var sample = Sample.duplicate()
	sample.button_pressed = false
	match NewTodo_Type.selected:
		TODO_ADD_FEATURE:
			sample.icon = load("res://addons/TopNote/Icons/Add.png")
		TODO_FIX_BUG:
			sample.icon = load("res://addons/TopNote/Icons/Fix.png")
		_:
			sample.icon = load("res://addons/TopNote/Icons/None.png")
	sample.type = NewTodo_Type.selected
	sample.text = NewTodo_Text.text
	sample.show()
	var children = Todo_list.get_children()
	for child in children: Todo_list.remove_child(child)
	Todo_list.add_child(sample)
	for child in children: Todo_list.add_child(child)
	NewTodo_Text.text = ""
	NewTodo_Type.selected = 2
	_save_todo()

func _on_sample_child_entered_tree(node):
	Remove.show()
	if Remove.confirmed.is_connected(_remove_todo): Remove.confirmed.disconnect(_remove_todo)
	Remove.confirmed.connect(_remove_todo.bind(node))

func _remove_todo(node):
	Todo_list.remove_child(node)
	_save_todo()


func _todo_search(new_text):
	for child in Todo_list.get_children(): Todo_list.remove_child(child)
	_load_todo(TodoSearch.text, TodoFilter.selected)


func _on_button_2_pressed():
	while NewCode_Name.text.begins_with(" "): NewCode_Name.text = NewCode_Name.text.erase(0)
	while NewCode_Name.text.ends_with(" "): NewCode_Name.text = NewCode_Name.text.reverse().erase(0).reverse()
	if NewCode_Name.text == "": return
	var sample = CodeSample.duplicate()
	sample.get_child(0).text = NewCode_Name.text
	sample.code = ""
	sample.show()
	Code_list.add_child(sample)
	NewCode_Name.text = ""
	_save_code()


func _on_code_editor_child_exiting_tree(node):
	_save_code()


func _on_search_text_changed(new_text):
	for child in Code_list.get_children(): Code_list.remove_child(child)
	_load_code(CodeSearch.text, CodeFilter.selected == 1)

func open_linked_note(object):
	if not object is Resource: return
	Tab.current_tab = 3
	Linked_Note.editable = true
	rid = str(object.get_rid())
	_load_linked()
	if str(rid) in Links:
		Linked_Note.text = Links[rid]
		return
	else:
		Linked_Note.text = ""


func _on_linked_notes_text_changed():
	_save_linked()


func _save_linked():
	if typeof(rid) != 0:
		Links[rid] = Linked_Note.text
	else:
		Links.erase(rid)
	file = FileAccess.open(LINKED, FileAccess.WRITE)
	var text = ""
	for item in Links:
		text += "|TN|" + item + "|LN|" + Links[item]
	file.store_string(text)
	file.close()
