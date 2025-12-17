extends Node2D

@onready var _player = $Player

func _on_mushroom_player_caught_mushroom(player: Node2D, mushroom: Node2D) -> void:
	player.add_mushroom(mushroom)

func _on_mushroom_take_damage(mushroom: Node2D) -> void:
	mushroom.die()

func _on_mushroom_dead(mushroom: Node2D) -> void:
	_player.remove_mushroom(mushroom)
	mushroom.call_deferred("queue_free")
