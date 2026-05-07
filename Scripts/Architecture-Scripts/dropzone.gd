extends PanelContainer

@export var expected_component: String = ""
var current_component: String = ""
var current_card_node: Control = null 

var current_badge_scene: PackedScene = null

var normal_color = Color(1, 1, 1, 0.4)
var active_color = Color(1, 1, 1, 1.0) 
var has_component: bool = false 

var drop_audio_player: AudioStreamPlayer # NEW: Audio Player Variable

func _ready() -> void:
	modulate = normal_color
	
	# --- NEW: SETUP DROP AUDIO PLAYER ---
	drop_audio_player = AudioStreamPlayer.new()
	drop_audio_player.stream = load("res://Assets/Audio/dropped-audio.mp3")
	
	# Since we are creating this node through code, we must add it as a child.
	# However, we DO NOT want it to be accidentally deleted when we clear out
	# the badge children in _drop_data. So we add it to the scene tree safely.
	add_child(drop_audio_player)

func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_BEGIN:
		modulate = active_color 
	elif what == NOTIFICATION_DRAG_END:
		if has_component == false:
			modulate = normal_color
		else:
			modulate = active_color

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data.has("badge_scene")

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if has_component:
		for child in get_children():
			# SAFEGUARD: Do not delete our audio player or particles!
			if child is not AudioStreamPlayer and child is not CPUParticles2D:
				child.queue_free() 
				
		if current_card_node != null:
			current_card_node.show()

	data["original_card"].hide()
			
	var new_badge = data["badge_scene"].instantiate()
	new_badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(new_badge)
	
	has_component = true
	modulate = active_color
	current_component = data["name"]
	current_card_node = data["original_card"]
	current_badge_scene = data["badge_scene"]
	
	# --- TRIGGER THE SOUND AND VISUAL EFFECTS ---
	drop_audio_player.play() # PLAY THE DROP SOUND!
	_play_placement_effects(new_badge)

# ---------------------------------------------------
# JUICY PLACEMENT ANIMATION, RIPPLE, & PARTICLES
# ---------------------------------------------------
func _play_placement_effects(badge: Control) -> void:
	# --- 1. THE BADGE "SNAP" ANIMATION ---
	badge.modulate.a = 0.0
	badge.scale = Vector2(1.4, 1.4) 
	
	await get_tree().process_frame
	if not is_instance_valid(badge): 
		return 
		
	badge.pivot_offset = badge.size / 2
	
	var badge_tween = create_tween()
	badge_tween.set_parallel(true)
	badge_tween.tween_property(badge, "scale", Vector2(1.0, 1.0), 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	badge_tween.tween_property(badge, "modulate:a", 1.0, 0.15)
	
	# --- 2. THE HIGH-VISIBILITY "SHOCKWAVE" RIPPLE ---
	var ripple = Panel.new()
	ripple.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ripple.set_anchors_preset(Control.PRESET_FULL_RECT)
	ripple.z_index = 10 
	
	var ring_style = StyleBoxFlat.new()
	ring_style.bg_color = Color(0, 0, 0, 0) 
	ring_style.border_color = Color(0.2, 0.6, 1.0, 1.0)
	ring_style.border_width_left = 6
	ring_style.border_width_right = 6
	ring_style.border_width_top = 6
	ring_style.border_width_bottom = 6
	ring_style.corner_radius_top_left = 8
	ring_style.corner_radius_top_right = 8
	ring_style.corner_radius_bottom_left = 8
	ring_style.corner_radius_bottom_right = 8
	
	ripple.add_theme_stylebox_override("panel", ring_style)
	add_child(ripple)
	
	ripple.pivot_offset = size / 2
	
	var ripple_tween = create_tween()
	ripple_tween.set_parallel(true)
	ripple_tween.tween_property(ripple, "scale", Vector2(1.5, 1.5), 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	ripple_tween.tween_property(ripple, "modulate:a", 0.0, 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	ripple_tween.finished.connect(ripple.queue_free)

	# --- 3. THE HIGH-VISIBILITY PARTICLE BURST ---
	var particles = CPUParticles2D.new()
	particles.emitting = false
	particles.amount = 25 
	particles.one_shot = true 
	particles.explosiveness = 0.95 
	particles.lifetime = 3 
	
	particles.spread = 180.0 
	particles.gravity = Vector2(0, 400) 
	particles.initial_velocity_min = 150.0 
	particles.initial_velocity_max = 300.0 
	
	particles.scale_amount_min = 6.0
	particles.scale_amount_max = 12.0
	particles.color = Color(0.2, 0.6, 1.0, 1.0)
	
	var fade_gradient = Gradient.new()
	fade_gradient.add_point(0.0, Color(1, 1, 1, 1)) 
	fade_gradient.add_point(1.0, Color(1, 1, 1, 0)) 
	particles.color_ramp = fade_gradient
	
	particles.position = size / 2
	
	add_child(particles)
	particles.emitting = true
	
	particles.finished.connect(particles.queue_free)

# ---------------------------------------------------
# Dragging from Dropzone to Dropzone
# ---------------------------------------------------
func _get_drag_data(_at_position: Vector2) -> Variant:
	if not has_component:
		return null 
		
	var drag_data = {
		"name": current_component,
		"badge_scene": current_badge_scene,
		"original_card": current_card_node
	}
	
	var preview = current_badge_scene.instantiate()
	preview.modulate = Color(1, 1, 1, 0.6)
	var preview_container = Control.new()
	preview_container.add_child(preview)
	preview.position = Vector2(-30, -30) 
	set_drag_preview(preview_container)
	
	current_card_node.show()
	for child in get_children():
		# SAFEGUARD: Do not delete our audio player!
		if child is not AudioStreamPlayer and child is not CPUParticles2D:
			child.queue_free()
		
	has_component = false
	current_component = ""
	current_card_node = null
	current_badge_scene = null
	modulate = normal_color
	
	return drag_data

# ---------------------------------------------------
# Click to Return (Tap to Remove)
# ---------------------------------------------------
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
		
		if has_component:
			if current_card_node != null:
				current_card_node.show()
			for child in get_children():
				# SAFEGUARD: Do not delete our audio player!
				if child is not AudioStreamPlayer and child is not CPUParticles2D:
					child.queue_free()
				
			has_component = false
			current_component = ""
			current_card_node = null
			current_badge_scene = null
			modulate = normal_color
