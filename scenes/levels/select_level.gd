extends "res://scenes/world_scene.gd"

@onready var _original_mushroom_house = $YSortedObjects/MushroomHouse
@onready var _back_to_main_menu_house := $YSortedObjects/Houses/HouseBack

func _ready() -> void:
	_initialize_camera()
	_hud.show_stats(false)
	_original_mushroom_house.call_deferred("queue_free")
	call_deferred("_update_house_labels")
	
func _update_house_labels() -> void:
	var houses: Array = get_tree().get_nodes_in_group(&"house")
	for house in houses:
		house.open_door(false)
		_update_house_label(house)
	_back_to_main_menu_house.open_door(true)

func _update_house_label(house: Node2D) -> void:
	if not house.has_meta(&"scene_name"):
		return
	var scene_name: String = house.get_meta(&"scene_name")
	var info = Globals.LEVELS[scene_name]
	if info == null:
		return

	var scores: Scores = Scores.new()
	var is_opened: bool = scores.get_score(scene_name) > 0 || Globals.get_level_to_continue() == scene_name

	var collected: String = ("%d" % [scores.get_score(scene_name)]) if scores.get_score(scene_name) > 0 else "?"
	var target: String = ("%d" % [scores.get_target(scene_name)]) if scores.get_target(scene_name) > 0 else "?"
	
	var label_value: String = ""
	
	if is_opened:
		label_value = "%s %s\n%s/%s" % [tr(&"COMMON_LEVEL"), info.name, collected, target]
	else:
		label_value = "???\n?/?"
		
	var spent_time: int = scores.get_time_spent(scene_name)
	if spent_time > 0:
		var res: String = _convert_time_spent_to_string(spent_time)
		label_value += "\n%s" % [res]

	house.set_house_label(label_value)

	house.open_door(is_opened)
	
func _convert_time_spent_to_string(value: int) -> String:
	@warning_ignore("integer_division")
	var minutes = int(value / 60)
	var seconds = value % 60
	return "%02d:%02d" % [minutes, seconds]

func _on_house_player_hit(_point: Node2D, scene_name: String) -> void:
	var found_level_name: String = ""
	for level_name in Globals.LEVELS.keys():
		if Globals.LEVELS[level_name].path.contains(scene_name):
			found_level_name = level_name
			break
	
	var scores: Scores = Scores.new()
	var is_opened: bool = scores.get_score(found_level_name) > 0 || Globals.get_level_to_continue() == found_level_name
	if not is_opened:
		return
	var target_scene = "res://scenes/levels/%s.tscn" % [scene_name]
	Transition.change_scene(target_scene)

func _on_house_back_player_hit(_point: Node2D) -> void:
	Transition.change_scene("res://scenes/levels/menu_level.tscn")
