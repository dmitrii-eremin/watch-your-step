extends Node
class_name LevelGenerator

var PlayerScene: PackedScene = preload("res://scenes/player.tscn")

class WorldObjects:
	var tilemap: TileMapLayer
	var second_layer: TileMapLayer
	var y_sorted_objects: Node2D

	func _init(world: Node2D) -> void:
		self.tilemap = world.get_node("WorldMap/TileMapLayer")
		self.second_layer = world.get_node("WorldMap/SecondGroundLevelLayer")
		self.y_sorted_objects = world.get_node("YSortedObjects")

	func is_valid() -> bool:
		return self.tilemap != null and self.second_layer != null and self.y_sorted_objects != null

func generate(world: Node2D) -> void:
	var objects: WorldObjects = WorldObjects.new(world)
	if not objects.is_valid():
		return

	_create_player(objects)

func _create_player(objects: WorldObjects, position: Vector2 = Vector2.ZERO) -> void:
	var player = PlayerScene.instantiate()
	objects.y_sorted_objects.add_child(player)
	player.global_position = position

	var camera: Camera2D = Camera2D.new()
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 12
	player.add_child(camera)
