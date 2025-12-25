extends "res://scenes/world_scene.gd"

@onready var _original_mushroom_house = $YSortedObjects/MushroomHouse

func _ready() -> void:
	_initialize_camera()
	_hud.show_stats(false)
	_original_mushroom_house.call_deferred("queue_free")

func _on_house_player_hit(_point: Node2D, scene_name: String) -> void:
	var target_scene = "res://scenes/levels/%s.tscn" % [scene_name]
	Transition.change_scene(target_scene)
