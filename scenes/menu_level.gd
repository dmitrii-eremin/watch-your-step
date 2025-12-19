extends "res://scenes/world_scene.gd"

@onready var _original_mushroom_house = $YSortedObjects/MushroomHouse

func _ready() -> void:
	_initialize_camera()
	_hud.show_stats(false)
	_original_mushroom_house.call_deferred("queue_free")

func _on_start_game(_point: Node2D) -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/levels/level_03.tscn")
