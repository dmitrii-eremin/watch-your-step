extends CanvasLayer

@onready var _stats_container: VBoxContainer = $MarginContainer/Control/StatsVBoxContainer
@onready var _mushrooms_count_label: Label = $MarginContainer/Control/StatsVBoxContainer/HBoxContainer/CaughtMushroomsLabel
@onready var _saved_mushrooms_label: Label = $MarginContainer/Control/StatsVBoxContainer/HBoxContainer2/SavedMushroomsLabel
@onready var _pause_button := $MarginContainer/Control/PauseButton
@onready var _pause_menu = $PauseMenu

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
	_pause_button.visible = visibility
	
func _ready() -> void:
	_original_mushrooms_count = get_tree().get_nodes_in_group("mushroom").size()
	update_mushrooms()
	_update_collected_mushrooms_label()

func _update_collected_mushrooms_label() -> void:
	_saved_mushrooms_label.text = "%d/%d" % [_collected_mushrooms_count, _original_mushrooms_count]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_pause_button_pressed()

func _on_pause_button_pressed() -> void:
	if not _pause_button.visible:
		return
	_pause_menu.pause()
