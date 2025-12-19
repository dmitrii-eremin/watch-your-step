extends Node2D

@onready var _collected: Label = $CanvasLayer/CollectedLabel

func _ready() -> void:
	_collected.text = "%d/%d" % [
		Globals.collected_mushrooms_count,
		Globals.target_mushrooms_count,
	]

func _process(_delta: float) -> void:
	if Input.is_anything_pressed():
		_goto_next_level()

func _goto_next_level() -> void:
	var next_level: String = Globals.get_next_level()
	if next_level.is_empty():
		Transition.change_scene("res://scenes/levels/menu_level.tscn")
	else:
		Globals.current_level = next_level
		Transition.change_scene(Globals.LEVELS[next_level])
