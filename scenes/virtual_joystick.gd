extends Control

@export var stick_radius: float = 30.0
@export var deadzone: float = 10.0
@export var base_size: float = 80.0
@export var base_color: Color = Color(1, 1, 1, 0.2)
@export var stick_color: Color = Color(1, 1, 1, 0.6)

signal on_joystick_input(direction: Vector2)

var _is_pressed: bool = false
var _touch_index: int = -1
var _stick_position: Vector2 = Vector2.ZERO
var _base_position: Vector2 = Vector2.ZERO
var _current_touch_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	_base_position = get_rect().size / 2

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		_handle_touch_input(event)
	elif event is InputEventScreenDrag and _is_pressed and event.index == _touch_index:
		_current_touch_position = event.position
		get_tree().root.set_input_as_handled()

func _handle_touch_input(event: InputEventScreenTouch) -> void:
	if event.pressed:
		if not _is_pressed and event.position.y > 48:
			_is_pressed = true
			_touch_index = event.index
			_base_position = event.position - global_position
			_stick_position = _base_position
			_current_touch_position = event.position
			queue_redraw()
	else:
		if _touch_index == event.index:
			_is_pressed = false
			_touch_index = -1
			_stick_position = _base_position
			on_joystick_input.emit(Vector2.ZERO)
			queue_redraw()

func _process(_delta: float) -> void:
	if _is_pressed and _touch_index >= 0:
		var local_pos = _current_touch_position - global_position
		var direction = (local_pos - _base_position).normalized()
		var distance = (local_pos - _base_position).length()
		
		if distance < deadzone:
			_stick_position = _base_position
			on_joystick_input.emit(Vector2.ZERO)
		else:
			var clamped_distance = min(distance, stick_radius)
			_stick_position = _base_position + direction * clamped_distance
			var normalized_input = direction * (clamped_distance / stick_radius)
			on_joystick_input.emit(normalized_input)
		
		queue_redraw()

func _draw() -> void:
	if not _is_pressed:
		return
	
	# Draw base circle
	draw_circle(_base_position, base_size / 2, base_color)
	
	# Draw stick circle
	draw_circle(_stick_position, stick_radius / 2, stick_color)
