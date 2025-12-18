extends Node
class_name LevelGenerator

var PlayerScene: PackedScene = preload("res://scenes/player.tscn")
var CameraScene: PackedScene = preload("res://scenes/player_camera.tscn")

enum GroundTileType {
	Grass,
	Water,
}

const CELL_SIZE: int = 16

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

	var world_size: Vector2i = Vector2i(100, 70)
	var data: Dictionary[Vector2i, GroundTileType] = _create_ground(world_size)

	_create_player(objects, world_size)
	_render_data_to_nodes(objects, data)

func _render_data_to_nodes(objects: WorldObjects, data: Dictionary[Vector2i, GroundTileType]) -> void:
	for coords in data.keys():
		var cell: GroundTileType = data[coords]
		match cell:
			GroundTileType.Grass:
				objects.tilemap.set_cell(Vector2i(coords.x, coords.y), 0, Vector2i(3, 1))
			GroundTileType.Water:
				pass

func _create_ground(world_size: Vector2i) -> Dictionary[Vector2i, GroundTileType]:
	var data: Dictionary[Vector2i, GroundTileType] = {}
	for ix in range(world_size.x):
		for iy in range(world_size.y):
			data[Vector2i(ix, iy)] = GroundTileType.Grass
	return data

func _create_player(objects: WorldObjects, world_size: Vector2i, position: Vector2 = Vector2.ZERO) -> void:
	var player = PlayerScene.instantiate()
	objects.y_sorted_objects.add_child(player)
	player.global_position = position

	var camera = CameraScene.instantiate()
	camera.limit_right = world_size.x * CELL_SIZE
	camera.limit_bottom = world_size.y * CELL_SIZE

	player.add_child(camera)
