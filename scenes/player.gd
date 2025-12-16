extends CharacterBody2D

@export var speed: float = 50.0

@onready var _sprite = $AnimatedSprite2D

var _old_velocity: Vector2 = Vector2.ONE
var _mushrooms: Array[Node2D] = []

func add_mushroom(mushroom: Node2D) -> void:
	_mushrooms.push_back(mushroom)
	mushroom.set_is_caught(true)

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("go_left", "go_right", "go_up", "go_down")
	if velocity.x != 0:
		_old_velocity = velocity
	velocity = speed * direction
	move_and_slide()
	for mushroom in _mushrooms:
		mushroom.set_target(global_position)

func _process(_delta: float) -> void:
	_select_animation()

func _select_animation() -> void:
	if (velocity.x < 0 and _old_velocity.x > 0) or (velocity.x > 0 and _old_velocity.x < 0):
		_sprite.flip_h = velocity.x < 0
	if velocity.x != 0 or velocity.y != 0:
		_sprite.play("walk")
	else:
		_sprite.play("default")
