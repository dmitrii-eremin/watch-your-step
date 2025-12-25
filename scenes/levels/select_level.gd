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
		_update_house_label(house)

func _update_house_label(house: Node2D) -> void:
	var scene_name: Variant = house.get_meta(&"scene_name")
	if scene_name == null:
		return
	var info = Globals.LEVELS[scene_name]
	if info == null:
		return
		
	var scores: Scores = Scores.new()
	var collected: String = ("%d" % [scores.get_score(scene_name)]) if scores.get_score(scene_name) > 0 else "?"
	var target: String = ("%d" % [scores.get_target(scene_name)]) if scores.get_target(scene_name) > 0 else "?"
	house.set_house_label("LEVEL %s\n%s/%s" % [info.name, collected, target])

func _on_house_player_hit(_point: Node2D, scene_name: String) -> void:
	var target_scene = "res://scenes/levels/%s.tscn" % [scene_name]
	Transition.change_scene(target_scene)
