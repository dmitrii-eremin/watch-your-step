extends Control

signal on_resume()

@onready var _main_menu_button: Button = $MainMenuButton
@onready var _resume_button: Button = $ResumeButton

func pause() -> void:
	get_tree().paused = true
	show()

func _ready() -> void:
	set_process_input(true)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if _main_menu_button.get_global_rect().has_point(event.position):
			_on_main_menu_button_pressed()
		elif _resume_button.get_global_rect().has_point(event.position):
			_on_resume_button_pressed()

func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	hide()
	Transition.change_scene("res://scenes/levels/menu_level.tscn")
	
func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	hide()
	on_resume.emit()
