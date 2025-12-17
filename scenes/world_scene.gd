extends Node2D

@onready var _player = $YSortedObjects/Player
@onready var _hud = $HUD
@onready var _mushroom_dead_timer = $MushroomDeadTimer

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
	pass # Replace with function body.
