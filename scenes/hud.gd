extends CanvasLayer

signal time_is_out()

@onready var _stats_container: VBoxContainer = $MarginContainer/Control/StatsVBoxContainer
@onready var _mushrooms_count_label: Label = $MarginContainer/Control/StatsVBoxContainer/HBoxContainer/CaughtMushroomsLabel
@onready var _saved_mushrooms_label: Label = $MarginContainer/Control/StatsVBoxContainer/HBoxContainer2/SavedMushroomsLabel
@onready var _pause_button := $MarginContainer/Control/PauseButton
@onready var _pause_menu = $PauseMenu
@onready var _level_name = $MarginContainer/Control/VBoxContainer/LevelName
@onready var _clock = $MarginContainer/Control/VBoxContainer/Clock

@onready var _overall_stats_container := $MarginContainer/Control/OverallStatsContainer
@onready var _overall_mushrooms_label := $MarginContainer/Control/OverallStatsContainer/HBoxContainer/MushroomsCountLabel

var _collected_mushrooms_count: int = 0
var _original_mushrooms_count: int = 0

var _scores: Scores = Scores.new()

func get_time_left() -> int:
	return _clock.get_time_left()

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
	_clock.visible = visibility
	_level_name.visible = visibility
	_overall_stats_container.visible = not visibility
	if visibility:
		_clock.start()
	else:
		_clock.stop(true)
		
func update_metadata() -> void:
	_level_name.text = Globals.LEVELS[Globals.current_level].name
	
	if Globals.LEVELS.has(Globals.current_level):
		var level_info = Globals.LEVELS[Globals.current_level]
		_clock.start(level_info.seconds)

func _ready() -> void:
	_original_mushrooms_count = get_tree().get_nodes_in_group("mushroom").size()
	update_mushrooms()
	_update_collected_mushrooms_label()
	update_metadata()
	_update_overall_stats()

func _update_collected_mushrooms_label() -> void:
	_saved_mushrooms_label.text = "%d/%d" % [_collected_mushrooms_count, _original_mushrooms_count]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_pause_button_pressed()

func _on_pause_button_pressed() -> void:
	if not _pause_button.visible:
		return
	_pause_menu.pause()

func _on_clock_time_is_out() -> void:
	time_is_out.emit()
	
func _update_overall_stats() -> void:
	var scores := _scores.get_all_scores()
	var collected: int = 0
	var total: int = 0
	for score in scores:
		collected += score.collected
		total += score.total
	var total_s: String = ("%d" % [total]) if _scores.is_game_completed() else "??"
	_overall_mushrooms_label.text = "%d/%s" % [collected, total_s]
