extends Camera2D

# Touchpad/pan controls
var pan_speed: float = 2.0
var zoom_speed: float = 0.2
var min_zoom: float = 0.2
var max_zoom: float = 3.0

# Track if we're currently panning
var is_panning: bool = false
var last_pan_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	# Enable input handling
	set_process_input(true)

func _input(event: InputEvent) -> void:
	# Handle pan gestures (trackpad/touchpad)
	if event is InputEventPanGesture:
		handle_pan(event as InputEventPanGesture)
	
	# Handle pinch zoom gesture
	elif event is InputEventMagnifyGesture:
		handle_zoom(event as InputEventMagnifyGesture)
	
	# Handle scroll wheel zoom (for mouse on desktop)
	elif event is InputEventMouseButton:
		handle_mouse_wheel(event as InputEventMouseButton)

func handle_pan(event: InputEventPanGesture) -> void:
	# Move camera based on pan gesture delta
	var pan_delta = event.delta * pan_speed
	
	# Move camera in opposite direction of pan (intuitive panning)
	global_position += pan_delta / zoom.x

func handle_zoom(event: InputEventMagnifyGesture) -> void:
	# Adjust zoom based on pinch gesture
	# event.factor > 1 means pinching out (zoom in)
	# event.factor < 1 means pinching in (zoom out)
	var new_zoom = zoom.x * event.factor
	
	# Clamp zoom to min/max values
	zoom = Vector2.ONE * clamp(new_zoom, min_zoom, max_zoom)

func handle_mouse_wheel(event: InputEventMouseButton) -> void:
	# Scroll up = zoom in, scroll down = zoom out
	if event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom = Vector2.ONE * clamp(zoom.x + zoom_speed, min_zoom, max_zoom)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom = Vector2.ONE * clamp(zoom.x - zoom_speed, min_zoom, max_zoom)
