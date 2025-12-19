extends CanvasLayer

signal on_resume()

func pause() -> void:
	get_tree().paused = true
	show()

func _ready() -> void:
	set_process_input(true)

func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	hide()
	Transition.change_scene("res://scenes/levels/menu_level.tscn")
	
func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	hide()
	on_resume.emit()
