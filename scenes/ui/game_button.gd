@tool
extends Control

signal pressed()

@export var title: String = ""

@onready var _btn: TextureButton = $TextureButton
@onready var _label: Label = $TextureButton/MarginContainer/Label

var _pressed: bool = false

func _ready() -> void:
	_label.text = title

func _on_texture_button_pressed() -> void:
	pressed.emit()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if _btn.get_global_rect().has_point(event.position):
			_btn.toggle_mode = true
			_btn.button_pressed = true
			_pressed = true
	elif event is InputEventMouseButton and not event.pressed and _pressed:
		_btn.toggle_mode = false
		_btn.button_pressed = false
		_on_texture_button_pressed()
