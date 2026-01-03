extends StaticBody2D

enum Type {
	Silver,
	Golden,
}

@export var type: Type = Type.Silver

@onready var _sprite := $AnimatedSprite2D
@onready var _label := $Label

func _ready() -> void:
	match type:
		Type.Silver:
			_sprite.play("silver")
			_label.text = "GAME_COMPLETED"
		Type.Golden:
			_sprite.play("golden")
			_label.text = "ALL_MUSHROOMS_COLLECTED"
