extends Node2D

@onready var _player: Node2D = $YSortedObjects/Player
@onready var _hud: CanvasLayer = $HUD
@onready var _mushroom_dead_timer: Timer = $MushroomDeadTimer
@onready var _tilemap: TileMapLayer = $WorldMap/TileMapLayer
@onready var _camera = $YSortedObjects/Player/PlayerCamera

func _ready() -> void:
	var world_size: Rect2i = _tilemap.get_used_rect()
	_camera.limit_left = world_size.position.x
	_camera.limit_top = world_size.position.y
	_camera.limit_right = world_size.size.x
	_camera.limit_bottom = world_size.size.y

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

func _on_mushroom_house_player_hit(point: Node2D) -> void:
	_player.save_mushrooms(point)

func _on_mushroom_collected(mushroom: Node2D) -> void:
	_player.remove_mushroom(mushroom)
	_hud.call_deferred("collect_mushroom")
	_hud.call_deferred("update_mushrooms")
	_mushroom_dead_timer.start()

func _on_virtual_joystick_on_joystick_input(direction: Vector2) -> void:
	_player.update_virtual_joystick(direction)
