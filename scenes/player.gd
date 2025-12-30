extends CharacterBody2D

signal dead()

@export var speed: float = 75.0
@export var checkpoint_distance: float = 20.0

@onready var _sprite = $AnimatedSprite2D
@onready var _neko_sprite = $NekoSprite2D
@onready var _died_timer: Timer = $DiedTimer
@onready var _follow_points: FollowPoints = $FollowPoints

@onready var _sound_steps := $Sounds/Steps

var _old_velocity: Vector2 = Vector2.ONE
var _mushrooms: Array[Node2D] = []
var _is_dead: bool = false
var _virtual_joystick: Vector2 = Vector2.ZERO

func update_virtual_joystick(direction: Vector2) -> void:
	_virtual_joystick = direction

func add_mushroom(mushroom: Node2D) -> void:
	_mushrooms.push_back(mushroom)
	mushroom.set_is_caught(true)

func free_mushrooms() -> void:
	for m in _mushrooms:
		m.set_is_caught(false)
	_mushrooms.clear()
	_follow_points.set_mushrooms_count(0)
	
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
	_follow_points.clear()
	_sprite.play(&"die")
	_neko_sprite.play(&"die")

func _physics_process(_delta: float) -> void:
	if _is_dead:
		return

	_update_velocity()
	move_and_slide()
	_process_collisions()

	_follow_points.update(_mushrooms)

func _process(_delta: float) -> void:
	_select_animation()
	_play_sounds()
	
func _ready() -> void:
	_sprite.stop()
	_neko_sprite.stop()
	_select_animation()
	
func _play_sounds() -> void:
	if _sprite.animation == &"walk" and not _sound_steps.playing:
		_sound_steps.play()
	
func _process_collisions() -> void:
	for i in range(get_slide_collision_count()):
		var col = get_slide_collision(i)
		var body = col.get_collider()
		if body.is_in_group("enemy"):
			take_damage_and_die()

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

func _on_animated_sprite_2d_animation_finished() -> void:
	if _sprite.animation == &"die":
		_died_timer.start()

func _on_died_timer_timeout() -> void:
	dead.emit()
