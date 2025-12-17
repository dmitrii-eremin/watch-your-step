extends CanvasLayer

@onready var _mushrooms_count_label: Label = $MarginContainer/Control/VBoxContainer/HBoxContainer/CaughtMushroomsLabel
@onready var _saved_mushrooms_label: Label = $MarginContainer/Control/VBoxContainer/HBoxContainer2/SavedMushroomsLabel

func update_saved_mushrooms() -> void:
	_saved_mushrooms_label.text = "0"

func update_mushrooms() -> void:
	var all_mushrooms: Array = get_tree().get_nodes_in_group("mushroom")
	var caught_mushrooms: Array = all_mushrooms.filter(func(m): return m.is_caught())
	_mushrooms_count_label.text = "%d/%d" % [caught_mushrooms.size(), all_mushrooms.size()]
	
func _ready() -> void:
	update_mushrooms()
