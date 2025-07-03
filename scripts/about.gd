extends ActionScript

var popup: Window

func _run_action() -> void:
	popup = load("res://scripts/script_scenes/about.tscn").instantiate()
	add_child(popup)
	popup.close_requested.connect(func(): popup.queue_free())
