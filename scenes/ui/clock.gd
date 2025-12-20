extends Control

signal time_is_out()

@export var initial_seconds: int = 5 * 60

@onready var _current_seconds: int = initial_seconds
@onready var _label: Label = $Label
@onready var _timer: Timer = $Timer

func start(seconds: int = initial_seconds) -> void:
	_current_seconds = seconds
	_update_seconds()
	_timer.start()
	
func stop(reset_time: int) -> void:
	if reset_time:
		_current_seconds = initial_seconds
	_timer.stop()

func _ready() -> void:
	_update_seconds()
	
func _update_seconds() -> void:
	@warning_ignore("integer_division")
	var minutes = int(_current_seconds / 60)
	var seconds = _current_seconds % 60
	_label.text = "%02d:%02d" % [minutes, seconds]

func _on_timer_timeout() -> void:
	_current_seconds -= 1
	if _current_seconds <= 0:
		time_is_out.emit()
		_current_seconds = 0
		_timer.stop()
	_update_seconds()
