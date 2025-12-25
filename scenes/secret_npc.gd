extends CharacterBody2D

const _not_ready_yet: String = "I am not ready yet\nCome back later."

@onready var _label: Label = $Label

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_label.text = _not_ready_yet
		_label.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_label.visible = false
