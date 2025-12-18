extends Camera2D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"look_at_whole_world"):
		_switch_zoom()

func _switch_zoom() -> void:
	get_tree().quit()
