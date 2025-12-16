extends CharacterBody2D

@export var speed: float = 75.0
@export var checkpoint_distance: float = 20.0

@onready var _sprite = $AnimatedSprite2D
@onready var _old_global_pos: Vector2 = global_position

var _old_velocity: Vector2 = Vector2.ONE
var _mushrooms: Array[Node2D] = []
var _checkpoints: Array[Vector2] = []

func add_mushroom(mushroom: Node2D) -> void:
	_mushrooms.push_back(mushroom)
	mushroom.set_is_caught(true)

func _physics_process(_delta: float) -> void:
	_update_velocity()
	
	move_and_slide()
	
	_update_checkpoints()
	
	for i in range(_mushrooms.size()):
		var target: Vector2 = _checkpoints[i] if i < _checkpoints.size() else _checkpoints[_checkpoints.size() - 1]
		_mushrooms[i].set_target(target)

func _process(_delta: float) -> void:
	_select_animation()
	
func _update_checkpoints() -> void:
	var diff: Vector2 = global_position - _old_global_pos
	if diff.length_squared() < checkpoint_distance ** 2:
		return
	var checkpoint: Vector2 = _old_global_pos + diff.normalized() * checkpoint_distance
	_checkpoints.push_front(checkpoint)
	_old_global_pos = checkpoint
	if _checkpoints.size() > _mushrooms.size() + 1:
		_checkpoints.resize(_mushrooms.size() + 1)
	
func _update_velocity() -> void:
	var direction: Vector2 = Input.get_vector("go_left", "go_right", "go_up", "go_down")
	if velocity.x != 0:
		_old_velocity = velocity
	velocity = speed * direction

func _select_animation() -> void:
	if (velocity.x < 0 and _old_velocity.x > 0) or (velocity.x > 0 and _old_velocity.x < 0):
		_sprite.flip_h = velocity.x < 0
	if velocity.x != 0 or velocity.y != 0:
		_sprite.play("walk")
	else:
		_sprite.play("default")
