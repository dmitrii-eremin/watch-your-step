extends Node2D

func _on_mushroom_player_caught_mushroom(player: Node2D, mushroom: Node2D) -> void:
	player.add_mushroom(mushroom)
