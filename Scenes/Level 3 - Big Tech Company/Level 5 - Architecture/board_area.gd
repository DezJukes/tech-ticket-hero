extends Control

# Grab the TextureRect that holds all your game pieces
@onready var canvas = $TextureRect


# Set your zoom limits (0.5 is half size, 2.5 is huge)
var min_zoom: float = 0.5
var max_zoom: float = 2.5

# Variables for Mouse & Touch tracking
var is_panning: bool = false
var active_touches: Dictionary = {}

# --- NEW: PAN DEADZONE ---
var pan_deadzone: float = 15.0 
var current_pan_distance: float = 0.0

func _ready() -> void:
	clip_contents = true 

func _gui_input(event: InputEvent) -> void:
	
	# If Godot detects the player is holding a game piece, freeze the board!
	if get_viewport().gui_is_dragging():
		active_touches.clear() 
		is_panning = false
		current_pan_distance = 0.0 # Reset the tracker
		return 
		
	# ---------------------------------------------------
	# MOBILE TOUCH LOGIC (ANDROID / iOS)
	# ---------------------------------------------------
	if event is InputEventScreenTouch:
		if event.pressed:
			active_touches[event.index] = event.position
			# NEW: Reset the distance tracker when they first touch the screen
			current_pan_distance = 0.0 
		else:
			active_touches.erase(event.index)

	elif event is InputEventScreenDrag:
		if active_touches.size() == 1:
			# --- 1-FINGER PAN ---
			# NEW: Add up how far the finger has moved
			current_pan_distance += event.relative.length()
			
			# NEW: Only move the board if they have dragged past the deadzone limit!
			if current_pan_distance > pan_deadzone:
				var new_pos = canvas.position + event.relative
				canvas.position = _clamp_position(new_pos)
				
			active_touches[event.index] = event.position

		elif active_touches.size() == 2:
			# --- 2-FINGER PINCH TO ZOOM & PAN ---
			var keys = active_touches.keys()
			var pos0 = active_touches[keys[0]]
			var pos1 = active_touches[keys[1]]

			var old_pos0 = pos0
			var old_pos1 = pos1

			if event.index == keys[0]:
				old_pos0 = pos0 - event.relative
				pos0 = event.position
			elif event.index == keys[1]:
				old_pos1 = pos1 - event.relative
				pos1 = event.position

			var old_dist = old_pos0.distance_to(old_pos1)
			var new_dist = pos0.distance_to(pos1)

			var old_center = (old_pos0 + old_pos1) / 2.0
			var new_center = (pos0 + pos1) / 2.0

			var new_pos = canvas.position + (new_center - old_center)
			canvas.position = _clamp_position(new_pos)

			if old_dist > 10.0: 
				var zoom_factor = new_dist / old_dist
				_zoom_at_point(zoom_factor, new_center)

			active_touches[event.index] = event.position

	# ---------------------------------------------------
	# PC MOUSE LOGIC (FOR EASY TESTING)
	# ---------------------------------------------------
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE or event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				is_panning = true
				mouse_default_cursor_shape = Control.CURSOR_DRAG 
			else:
				is_panning = false
				mouse_default_cursor_shape = Control.CURSOR_ARROW

		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.is_pressed():
			_zoom_at_point(1.1, event.position)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.is_pressed():
			_zoom_at_point(0.9, event.position)

	elif event is InputEventMouseMotion and is_panning:
		if active_touches.is_empty():
			var new_pos = canvas.position + event.relative
			canvas.position = _clamp_position(new_pos)

# ---------------------------------------------------
# ZOOM CALCULATION
# ---------------------------------------------------
func _zoom_at_point(zoom_factor: float, point_pos: Vector2) -> void:
	var old_scale = canvas.scale
	var new_scale = old_scale * zoom_factor
	
	new_scale.x = clamp(new_scale.x, min_zoom, max_zoom)
	new_scale.y = clamp(new_scale.y, min_zoom, max_zoom)

	if new_scale == old_scale:
		return 

	var local_pos = (point_pos - canvas.position) / old_scale
	canvas.scale = new_scale
	
	# NEW: Even when zooming, make sure the board doesn't shrink away from the edges!
	var new_pos = point_pos - (local_pos * new_scale)
	canvas.position = _clamp_position(new_pos)

# ---------------------------------------------------
# NEW: THE INVISIBLE WALL CALCULATION
# ---------------------------------------------------
func _clamp_position(target_pos: Vector2) -> Vector2:
	var scaled_size = canvas.size * canvas.scale
	var view_size = size # The size of the BoardArea container
	var clamped_pos = target_pos

	# --- X-AXIS LIMITS ---
	if scaled_size.x < view_size.x:
		# If zoomed out so the board is smaller than the screen, keep it contained inside
		clamped_pos.x = clamp(clamped_pos.x, 0, view_size.x - scaled_size.x)
	else:
		# If zoomed in so the board is huge, stop panning when the edge hits the screen edge
		clamped_pos.x = clamp(clamped_pos.x, view_size.x - scaled_size.x, 0)

	# --- Y-AXIS LIMITS ---
	if scaled_size.y < view_size.y:
		clamped_pos.y = clamp(clamped_pos.y, 0, view_size.y - scaled_size.y)
	else:
		clamped_pos.y = clamp(clamped_pos.y, view_size.y - scaled_size.y, 0)

	return clamped_pos
