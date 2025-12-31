extends Node

@onready var _sound_select := $Select

func play_select_sound() -> void:
	_sound_select.play()
