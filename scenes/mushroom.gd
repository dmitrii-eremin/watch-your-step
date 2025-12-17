extends CharacterBody2D

signal player_caught_mushroom(player: Node2D, mushroom: Node2D)
signal take_damage(mushroom: Node2D)
signal dead(mushroom: Node2D)

@export var speed: float = 75.0

@onready var _sprite = $AnimatedSprite2D

@onready var _target: Vector2 = global_position

var _old_velocity: Vector2 = Vector2.ONE
var _is_caught: bool = false
var _is_dying: bool = false 

func set_is_caught(value: bool) -> void:
	_is_caught = value
	
func set_target(target: Vector2) -> void:
	_target = target
	
func die() -> void:
	_is_dying = true

func _physics_process(_delta: float) -> void:
	if _is_dying:
		velocity = Vector2.ZERO
	else:
		var diff = _target - global_position
		var direction = (_target - global_position).normalized() if diff.length_squared() > 2 ** 2 else Vector2.ZERO
		if velocity.x != 0:
			_old_velocity = velocity
		velocity = speed * direction

	move_and_slide()
	_select_animation()

func _process(_delta: float) -> void:
	pass

func _select_animation() -> void:
	if _is_dying:
		_sprite.play("dead")
		return

	if (velocity.x < 0 and _old_velocity.x > 0) or (velocity.x > 0 and _old_velocity.x < 0):
		_sprite.flip_h = velocity.x < 0
	if velocity.x != 0 or velocity.y != 0:
		_sprite.play("walk")
	else:
		_sprite.play("default")

func _on_player_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if not _is_caught:
			player_caught_mushroom.emit(body, self)
		else:
			take_damage.emit(self)


func _on_animated_sprite_2d_animation_finished() -> void:
	if _sprite.animation == &"dead":
		dead.emit(self)
