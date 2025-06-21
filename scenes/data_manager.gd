extends Node

const MAIN_UI := "res://data/main_ui.ini"

var A: Array = [
	{"text": "Links...", "code": 10000},
	{"text": "Files...", "code": 10001},
	{"text": "Quotes...", "code": 10002},
	{"text": "Tables...", "code": 10003},
]

var B: Array = [
	{"text": "Signature...", "code": 3000 - 10000},
	{"text": "Date &  Time...", "code": 3001 - 10000},
	{"text": "Macros...", "code": 3002 - 10000},
	{"text": "Auto Backup...", "code": 3003 - 10000},
]

func _ready() -> void:
	SLib.save_file(MAIN_UI, A, "main_menu/references_menu")
	SLib.save_file(MAIN_UI, B, "main_menu/tools_submenu")
