extends Label

@export var offset: float = 10.0

var _original_position: Vector2
var _tween: Tween

func _ready() -> void:
	_original_position = position
	# if not Engine.is_editor_hint():
	start_bouncing()

func start_bouncing() -> void:
	if _tween:
		_tween.kill()
	
	_tween = create_tween()
	_tween.set_loops()
	
	# Jump up - fast at start, slows down as it reaches peak
	_tween.set_trans(Tween.TRANS_QUAD)
	_tween.set_ease(Tween.EASE_OUT)
	_tween.tween_property(self, "position:y", _original_position.y - offset, 1)
	
	# Fall down - accelerates like gravity
	_tween.set_trans(Tween.TRANS_QUAD)
	_tween.set_ease(Tween.EASE_IN)
	_tween.tween_property(self, "position:y", _original_position.y, 1)
