extends "res://scenes/world_scene.gd"

@onready var _original_mushroom_house = $YSortedObjects/MushroomHouse

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
	if is_opened:
		house.set_house_label("%s %s\n%s/%s" % [tr(&"COMMON_LEVEL"), info.name, collected, target])
	else:
		house.set_house_label("???\n?/?")
	house.open_door(is_opened)

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
