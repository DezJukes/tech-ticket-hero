extends Node2D
@export var radius: float = 40.0
@export var ring_color: Color = Color.DARK_GRAY
@export var thickness: float = 2.0
@export var dash_count: int = 12

var current_tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale = Vector2.ZERO
	hide()
	
func _draw() -> void:
	var angle_step = (PI * 2.0) / dash_count
	var dash_length = angle_step * 0.5 # 50% line, 50% empty space

	for i in range(dash_count):
		var start_angle = i * angle_step
		var end_angle = start_angle + dash_length
		# Draws a small segment of the circle
		draw_arc(Vector2.ZERO, radius, start_angle, end_angle, 8, ring_color, thickness, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if visible:
		rotation += 1.0 * delta # Adjust speed here

func set_active(is_active: bool) -> void:
	# Stop any currently running animation so they don't overlap
	if current_tween and current_tween.is_valid():
		current_tween.kill()
		
	current_tween = create_tween()
	
	# TRANS_BACK makes it slightly "overshoot" its target for a nice bouncy pop effect
	current_tween.set_trans(Tween.TRANS_BACK)
	current_tween.set_ease(Tween.EASE_OUT)
	
	if is_active:
		show() # Make visible before growing
		current_tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.3)
	else:
		# Shrink to 0, then hide it once the animation finishes
		current_tween.tween_property(self, "scale", Vector2.ZERO, 0.3)
		current_tween.tween_callback(hide)
