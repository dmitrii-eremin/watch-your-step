extends CharacterBody2D

@export var speed: float = 75.0
@export var checkpoint_distance: float = 20.0

@onready var _sprite = $AnimatedSprite2D
@onready var _neko_sprite = $NekoSprite2D
@onready var _old_global_pos: Vector2 = global_position

var _old_velocity: Vector2 = Vector2.ONE
var _mushrooms: Array[Node2D] = []
var _checkpoints: Array[Vector2] = []
var _is_dead: bool = false
var _virtual_joystick: Vector2 = Vector2.ZERO

func update_virtual_joystick(direction: Vector2) -> void:
	_virtual_joystick = direction

func add_mushroom(mushroom: Node2D) -> void:
	_mushrooms.push_back(mushroom)
	mushroom.set_is_caught(true)
	
func remove_mushroom(mushroom: Node2D) -> void:
	var index: int = _mushrooms.find(mushroom)
	if index == -1:
		return
	for i in range(_mushrooms.size() - 1, index - 1, -1):
		_mushrooms[i].set_is_caught(false)
		_mushrooms.remove_at(i)
	
func save_mushrooms(point: Node2D) -> void:
	for mushroom in _mushrooms:
		mushroom.set_final_target(point)
		
func set_neko_suit(is_suit_visible: bool) -> void:
	_neko_sprite.visible = is_suit_visible
	
func take_damage_and_die() -> void:
	if _is_dead:
		return
	_is_dead = true
	for mushroom in _mushrooms:
		mushroom.set_is_caught(false)
	_mushrooms.clear()
	_checkpoints.clear()
	_sprite.play(&"die")
	_neko_sprite.play(&"die")

func _physics_process(_delta: float) -> void:
	if _is_dead:
		return

	_update_velocity()
	
	move_and_slide()
	
	_process_collisions()
	_update_checkpoints()
	
	for i in range(_mushrooms.size()):
		var target: Vector2 = _checkpoints[i + 1] if i + 1 < _checkpoints.size() else _checkpoints[_checkpoints.size() - 1]
		_mushrooms[i].set_target(target)

func _process(_delta: float) -> void:
	_select_animation()
	
func _ready() -> void:
	_sprite.stop()
	_neko_sprite.stop()
	_select_animation()
	
func _process_collisions() -> void:
	for i in range(get_slide_collision_count()):
		var col = get_slide_collision(i)
		var body = col.get_collider()
		if body.is_in_group("enemy"):
			take_damage_and_die()
	
func _update_checkpoints() -> void:
	var diff: Vector2 = global_position - _old_global_pos
	if diff.length_squared() < checkpoint_distance ** 2:
		return
	var checkpoint: Vector2 = _old_global_pos + diff.normalized() * checkpoint_distance
	_checkpoints.push_front(checkpoint)
	_old_global_pos = checkpoint
	if _checkpoints.size() > _mushrooms.size() + 2:
		_checkpoints.resize(_mushrooms.size() + 2)
	
func _update_velocity() -> void:
	var direction: Vector2 = Input.get_vector("go_left", "go_right", "go_up", "go_down")
	if direction == Vector2.ZERO:
		direction = _virtual_joystick

	if velocity.x != 0:
		if _old_velocity.x != 0:
			_sprite.flip_h = velocity.x < 0
			_neko_sprite.flip_h = _sprite.flip_h
		_old_velocity = velocity
	velocity = speed * direction

func _select_animation() -> void:
	if _is_dead:
		return
	if (velocity.x < 0 and _old_velocity.x > 0) or (velocity.x > 0 and _old_velocity.x < 0):
		_sprite.flip_h = velocity.x < 0
	if velocity.x != 0 or velocity.y != 0:
		_sprite.play(&"walk")
		_neko_sprite.play(&"walk")
	else:
		_sprite.play(&"default")
		_neko_sprite.play(&"default")
