extends Control

@onready var logo = $Logo
@onready var loading_label = $CreditLabel

# Set where the game goes after the loading screen
var next_scene_path = "res://Scenes/Menu/main_menu.tscn"

# How many seconds should the loading screen stay visible?
var minimum_load_time = 2.5 

# Variables for the animated dots
var dot_timer: float = 0.0
var dot_count: int = 0

func _ready() -> void:
	# 1. Start completely invisible
	modulate.a = 0.0
	
	# 2. Make the logo gently "breathe" (scale up and down forever)
	# We set the pivot offset to the center so it grows from the middle!
	logo.pivot_offset = logo.size / 2 
	var breathe_tween = create_tween().set_loops()
	breathe_tween.tween_property(logo, "scale", Vector2(1.05, 1.05), 1.0).set_trans(Tween.TRANS_SINE)
	breathe_tween.tween_property(logo, "scale", Vector2(1.0, 1.0), 1.0).set_trans(Tween.TRANS_SINE)
	
	# 3. Fade in, wait, and fade out!
	var transition_tween = create_tween()
	transition_tween.tween_property(self, "modulate:a", 1.0, 0.5) # Fade in
	transition_tween.tween_interval(minimum_load_time)            # Hold
	transition_tween.tween_property(self, "modulate:a", 0.0, 0.5) # Fade out
	
	# When the fade out is totally finished, run the scene change function
	transition_tween.finished.connect(_go_to_next_scene)


func _process(delta: float) -> void:
	# 4. Animate the "..." on the Loading text
	dot_timer += delta
	
	# Update the dots every 0.4 seconds
	if dot_timer > 0.4: 
		dot_timer = 0.0
		dot_count += 1
		
		# Reset back to 0 after 3 dots
		if dot_count > 3:
			dot_count = 0
		
		# Build the string of dots
		var dots = ""
		for i in range(dot_count):
			dots += "."
			
		loading_label.text = "Loading" + dots


func _go_to_next_scene() -> void:
	# Swap to the main menu!
	get_tree().change_scene_to_file(next_scene_path)
