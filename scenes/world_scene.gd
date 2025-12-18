extends Node2D

@onready var _player: Node2D
@onready var _hud: CanvasLayer
@onready var _mushroom_dead_timer: Timer

func _ready() -> void:
	if not has_node("YSortedObjects/Player"):
		var gen: LevelGenerator = LevelGenerator.new()
		gen.generate(self)

	_player = $YSortedObjects/Player
	_hud = $HUD
	_mushroom_dead_timer = $MushroomDeadTimer

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
