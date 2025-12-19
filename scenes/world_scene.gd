extends Node2D

@onready var _player: Node2D = $YSortedObjects/Player
@onready var _hud: CanvasLayer = $HUD
@onready var _mushroom_dead_timer: Timer = $MushroomDeadTimer
@onready var _tilemap: TileMapLayer = $WorldMap/TileMapLayer
@onready var _camera = $YSortedObjects/Player/PlayerCamera

func _ready() -> void:
	_initialize_camera()
	_initialize_mushrooms()
	_initialize_house()
	
func _initialize_house() -> void:
	var houses = get_tree().get_nodes_in_group(&"house")
	for house in houses:
		house.player_hit.connect(_on_mushroom_house_player_hit)
	
func _initialize_mushrooms() -> void:
	var mushrooms = get_tree().get_nodes_in_group(&"mushroom")
	for mushroom in mushrooms:
		mushroom.player_caught_mushroom.connect(_on_mushroom_player_caught_mushroom)
		mushroom.take_damage.connect(_on_mushroom_take_damage)
		mushroom.dead.connect(_on_mushroom_dead)
		mushroom.collected.connect(_on_mushroom_collected)
	
func _initialize_camera() -> void:
	var world_size: Rect2i = _tilemap.get_used_rect()
	_camera.limit_enabled = true
	_camera.limit_left = world_size.position.x * _tilemap.tile_set.tile_size.x
	_camera.limit_top = world_size.position.y * _tilemap.tile_set.tile_size.y
	_camera.limit_right = (world_size.position.x + world_size.size.x) * _tilemap.tile_set.tile_size.x
	_camera.limit_bottom = (world_size.position.y + world_size.size.y) * _tilemap.tile_set.tile_size.y

func _on_mushroom_player_caught_mushroom(player: Node2D, mushroom: Node2D) -> void:
	player.add_mushroom(mushroom)
	_hud.update_mushrooms()

func _on_mushroom_take_damage(mushroom: Node2D) -> void:
	mushroom.die()

func _on_mushroom_dead(mushroom: Node2D) -> void:
	_player.remove_mushroom(mushroom)
	mushroom.call_deferred("queue_free")
	_hud.update_mushrooms()
	_mushroom_dead_timer.start()

func _on_mushroom_dead_timer_timeout() -> void:
	_hud.call_deferred("update_mushrooms")
	var mushrooms_left: int = get_tree().get_nodes_in_group("mushroom").size()
	if mushrooms_left == 0:
		_level_completed()

func _on_mushroom_house_player_hit(point: Node2D) -> void:
	_player.save_mushrooms(point)

func _on_mushroom_collected(mushroom: Node2D) -> void:
	_player.remove_mushroom(mushroom)
	_hud.call_deferred("collect_mushroom")
	_hud.call_deferred("update_mushrooms")
	_mushroom_dead_timer.start()

func _on_virtual_joystick_on_joystick_input(direction: Vector2) -> void:
	_player.update_virtual_joystick(direction)

func _level_completed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/levels/menu_level.tscn")