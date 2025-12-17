@tool
extends CharacterBody2D

enum Type {
	Slime,
	Snake,
	Fire,
	Ghost,
	Racoon,
	Lizard,
	Spider,
}

@export var speed: float = 20.0
@export var path_follower: PathFollow2D
@export var enemy_type: Type = Type.Slime

@onready var _sprite = $AnimatedSprite2D
@onready var _previous_position = global_position

const _sprite_frames: Dictionary = {
	Type.Slime: preload("res://animations/slime.tres"),
	Type.Snake: preload("res://animations/snake.tres"),
	Type.Fire: preload("res://animations/fire.tres"),
	Type.Ghost: preload("res://animations/ghost.tres"),
	Type.Racoon: preload("res://animations/racoon.tres"),
	Type.Lizard: preload("res://animations/lizard.tres"),
	Type.Spider: preload("res://animations/spider.tres"),
}

func _ready() -> void:
	_sprite.sprite_frames = _sprite_frames[enemy_type]
	path_follower.progress = 0.0
	
func _physics_process(delta: float) -> void:
	path_follower.progress += speed * delta
	_previous_position = global_position
	global_position = path_follower.global_position
	_select_animation()
	
func _select_animation() -> void:
	var direction = (global_position - _previous_position).normalized()
	if direction.x == 0 and direction.y == 0:
		_sprite.stop()
	elif abs(direction.x) > abs(direction.y):
		_sprite.play(&"go_left" if direction.x < 0 else &"go_right")
	else:
		_sprite.play(&"go_up" if direction.y < 0 else &"go_down")
