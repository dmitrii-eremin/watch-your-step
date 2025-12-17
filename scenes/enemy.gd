extends CharacterBody2D

@export var speed: float = 20.0
@export var path_follower: PathFollow2D

@onready var _sprite = $AnimatedSprite2D
@onready var _previous_position = global_position

func _ready() -> void:
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
