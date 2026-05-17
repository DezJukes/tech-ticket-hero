extends Control

# Grab the label from your scene tree
@onready var credit_label = $CreditLabel

# Safety variable to prevent double-tap crashes
var is_transitioning: bool = false 

func _ready() -> void:
	# 1. Start with the text totally invisible
	credit_label.modulate.a = 0.0
	
	# 2. Play the fade sequence!
	play_complete_sequence()


func play_complete_sequence() -> void:
	var tween = create_tween()
	
	# --- FADE IN --- (takes 1.5 seconds)
	tween.tween_property(credit_label, "modulate:a", 1.0, 1.5)
	
	# --- HOLD --- (stays on screen for 2 full seconds so they can read it)
	tween.tween_interval(2.0)
	
	# --- FADE OUT --- (takes 1.5 seconds)
	tween.tween_property(credit_label, "modulate:a", 0.0, 1.5)
	
	# Wait for the entire animation to finish...
	await tween.finished
	
	# Transition automatically if they didn't tap
	_go_to_credits()


# =========================
# GLOBAL INPUT (TAP TO SKIP)
# =========================
func _input(event: InputEvent) -> void:
	# Left click OR mobile tap
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed) or \
	   (event is InputEventScreenTouch and event.pressed):
		_go_to_credits()


func _go_to_credits() -> void:
	# Only change the scene if we aren't already changing it!
	if not is_transitioning:
		is_transitioning = true
		get_tree().change_scene_to_file("res://Scenes/Menu/Credits.tscn")
