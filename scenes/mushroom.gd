extends CharacterBody2D

signal player_caught_mushroom(player: Node2D, mushroom: Node2D)
signal take_damage(mushroom: Node2D)
signal dead(mushroom: Node2D)
signal collected(mushroom: Node2D)

@onready var _brown_mushroom_tileset = preload("res://animations/brown_mushroom.tres")
@onready var _blue_mushroom_tileset = preload("res://animations/blue_mushroom.tres")

@export var mushroom_speed: float = 25.0
@export var player_speed: float = 75.0

@onready var _sprite = $AnimatedSprite2D

@onready var _target: Vector2 = global_position
@onready var _original_position: Vector2 = global_position
var _final_target: Node2D

var _old_velocity: Vector2 = Vector2.ONE
var _is_caught: bool = false
var _is_dying: bool = false 
var _is_reached: bool = false

func set_is_caught(value: bool) -> void:
	_is_caught = value
	_sprite.sprite_frames = _blue_mushroom_tileset if _is_caught else _brown_mushroom_tileset
	if not _is_caught:
		set_target(_original_position)
	
func is_caught() -> bool:
	return _is_caught
	
func set_final_target(point: Node2D) -> void:
	_final_target = point
	collision_mask = 0
	
func set_target(target: Vector2) -> void:
	_target = target
	
func hit() -> void:
	take_damage.emit(self)
	
func die() -> void:
	_is_dying = true

func _physics_process(_delta: float) -> void:
	if _is_dying:
		velocity = Vector2.ZERO
	else:
		var target: Vector2 = _final_target.global_position if _final_target != null else _target
		var diff = target - global_position

		var direction = (target - global_position).normalized() if diff.length_squared() > 2 ** 2 else Vector2.ZERO
		if velocity.x != 0:
			_old_velocity = velocity
		var speed = player_speed if is_caught() else mushroom_speed
		velocity = speed * direction
		
		if _final_target != null and direction.length_squared() == 0:
			_on_reached_final_destination()

	move_and_slide()
	_select_animation()
	
func _on_reached_final_destination() -> void:
	if _is_reached:
		return
	_is_reached = true
	await create_tween().tween_property(self, "modulate:a", 0, 0.35).finished
	collected.emit(self)
	call_deferred("queue_free")

func _process(_delta: float) -> void:
	pass

func _select_animation() -> void:
	if _is_reached:
		_sprite.play("default")
		return

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
		elif _final_target == null:
			hit()
	elif body.is_in_group("enemy") and _final_target == null:
		hit()

func _on_animated_sprite_2d_animation_finished() -> void:
	if _sprite.animation == &"dead":
		dead.emit(self)
