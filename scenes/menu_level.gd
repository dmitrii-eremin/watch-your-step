extends "res://scenes/world_scene.gd"

@onready var original_mushroom_house = $YSortedObjects/MushroomHouse

func _ready() -> void:
	_initialize_camera()
	original_mushroom_house.call_deferred("queue_free")

func _on_start_game(_point: Node2D) -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_03.tscn")
