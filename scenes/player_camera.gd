extends Camera2D

var _zoomed_out: bool = false
var _zoom_tween: Tween

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"look_at_whole_world"):
		_switch_zoom()

func _switch_zoom() -> void:
	_zoomed_out = not _zoomed_out
	if _zoom_tween:
		_zoom_tween.kill()
	
	var target_zoom: Vector2
	if _zoomed_out:
		var world_width: int = limit_right - limit_left
		var world_height: int = limit_bottom - limit_top
		var viewport_width: float = get_viewport_rect().size.x
		var viewport_height: float = get_viewport_rect().size.y
		var zoom_x: float = viewport_width / world_width
		var zoom_y: float = viewport_height / world_height
		target_zoom = Vector2(minf(zoom_x, zoom_y), minf(zoom_x, zoom_y))
	else:
		target_zoom = Vector2(1.0, 1.0)
	
	_zoom_tween = get_tree().create_tween()
	_zoom_tween.tween_property(self, "zoom", target_zoom, 1.0)
	
