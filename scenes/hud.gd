extends CanvasLayer

@onready var _stats_container: VBoxContainer = $MarginContainer/Control/StatsVBoxContainer
@onready var _mushrooms_count_label: Label = $MarginContainer/Control/StatsVBoxContainer/HBoxContainer/CaughtMushroomsLabel
@onready var _saved_mushrooms_label: Label = $MarginContainer/Control/StatsVBoxContainer/HBoxContainer2/SavedMushroomsLabel

var _collected_mushrooms_count: int = 0
var _original_mushrooms_count: int = 0

func collect_mushroom() -> void:
	_collected_mushrooms_count += 1
	_update_collected_mushrooms_label()

func update_mushrooms() -> void:
	var all_mushrooms: Array = get_tree().get_nodes_in_group("mushroom")
	var caught_mushrooms: Array = all_mushrooms.filter(func(m): return m.is_caught())
	_mushrooms_count_label.text = "%d/%d" % [caught_mushrooms.size(), all_mushrooms.size()]
	
func show_stats(visibility: bool) -> void:
	_stats_container.visible = visibility
	
func _ready() -> void:
	_original_mushrooms_count = get_tree().get_nodes_in_group("mushroom").size()
	update_mushrooms()
	_update_collected_mushrooms_label()

func _update_collected_mushrooms_label() -> void:
	_saved_mushrooms_label.text = "%d/%d" % [_collected_mushrooms_count, _original_mushrooms_count]
