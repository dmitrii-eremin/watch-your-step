extends CanvasLayer

@onready var _mushrooms_count_label: Label = $MarginContainer/Control/HBoxContainer/Label

func update_mushrooms() -> void:
	var all_mushrooms: Array = get_tree().get_nodes_in_group("mushroom")
	var caught_mushrooms: Array = all_mushrooms.filter(func(m): return m.is_caught())
	_mushrooms_count_label.text = "%d / %d" % [caught_mushrooms.size(), all_mushrooms.size()]
	
func _ready() -> void:
	update_mushrooms()
