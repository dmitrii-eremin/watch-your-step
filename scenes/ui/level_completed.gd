extends Node2D

@export var is_died: bool = false

@onready var _title_label: Label = $CanvasLayer/JumpingLabel
@onready var _action_label: Label = $CanvasLayer/JumpingLabel2
@onready var _collected: Label = $CanvasLayer/CollectedLabel

const TITLES: Dictionary[bool, String] = {
	false: "Level Completed!",
	true: "You lost. Maybe next time...",
}

const ACTIONS: Dictionary[bool, String] = {
	false: "Press to continue...",
	true: "Press to restart...",
}

func set_is_died(died: bool) -> void:
	is_died = died
	_update_texts()

func _ready() -> void:
	set_is_died(Globals.is_died)
	_update_texts()
	Globals.is_died = false

func _update_texts() -> void:
	_title_label.text = TITLES[is_died]
	_action_label.text = ACTIONS[is_died]
	_collected.text = "%d/%d" % [
		Globals.collected_mushrooms_count,
		Globals.target_mushrooms_count,
	]

func _process(_delta: float) -> void:
	if Input.is_anything_pressed():
		_goto_next_level()

func _goto_next_level() -> void:
	var next_level: String = Globals.get_next_level() if not is_died else Globals.current_level
	if next_level.is_empty():
		Transition.change_scene("res://scenes/levels/menu_level.tscn")
	else:
		Globals.current_level = next_level
		Transition.change_scene(Globals.LEVELS[next_level])
