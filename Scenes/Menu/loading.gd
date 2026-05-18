extends Control

# ==========================================
# SCENE NODES
# ==========================================
@onready var logo = $Logo
@onready var loading_label = $CreditLabel
@onready var knowledge_label = $Knowledge # Your new label for tips/quotes

# ==========================================
# LOADING SETTINGS
# ==========================================
# How many seconds should the loading screen stay visible?
var minimum_load_time = 3.5 

# Variables used to calculate the animated "..." dots
var dot_timer: float = 0.0
var dot_count: int = 0

# ==========================================
# KNOWLEDGE BASE
# ==========================================
# An array of industry sayings, tips, and encouragements. 
# You can add as many as you want here!
var tech_quotes: Array[String] = [
	"First, solve the problem. Then, write the code.",
	"Clean code always looks like it was written by someone who cares.",
	"Remember to always back up your data!",
	"Every Senior Engineer was once a beginner. Keep deploying!",
	"It's not a bug, it's an undocumented feature.",
	"Architecture is about making the important stuff easy.",
	"A good programmer always looks both ways before crossing a one-way street."
]

# ==========================================
# INITIALIZATION
# ==========================================
func _ready() -> void:
	# 1. Pick a random quote and set it to the Knowledge label instantly
	knowledge_label.text = tech_quotes.pick_random()
	
	# 2. Start the screen completely invisible so we can fade it in
	modulate.a = 0.0
	
	# 3. Make the logo gently "breathe" (scale up and down looping forever)
	logo.pivot_offset = logo.size / 2 # Ensures it grows from the center
	var breathe_tween = create_tween().set_loops()
	breathe_tween.tween_property(logo, "scale", Vector2(1.05, 1.05), 1.0).set_trans(Tween.TRANS_SINE)
	breathe_tween.tween_property(logo, "scale", Vector2(1.0, 1.0), 1.0).set_trans(Tween.TRANS_SINE)
	
	# 4. Handle the cinematic Fade In -> Hold -> Fade Out
	var transition_tween = create_tween()
	transition_tween.tween_property(self, "modulate:a", 1.0, 0.5) # Fade in over 0.5 sec
	transition_tween.tween_interval(minimum_load_time)            # Hold on screen
	transition_tween.tween_property(self, "modulate:a", 0.0, 0.5) # Fade out over 0.5 sec
	
	# 5. When the fade out is totally finished, trigger the scene change function
	transition_tween.finished.connect(_go_to_next_scene)

# ==========================================
# FRAME PROCESSING (ANIMATIONS)
# ==========================================
func _process(delta: float) -> void:
	# Animate the "..." on the Loading text at the bottom right
	dot_timer += delta
	
	# Update the dots every 0.4 seconds to create a typing effect
	if dot_timer > 0.4: 
		dot_timer = 0.0
		dot_count += 1
		
		# Reset back to 0 after 3 dots to loop the animation
		if dot_count > 3:
			dot_count = 0
		
		# Build the string of dots dynamically
		var dots = ""
		for i in range(dot_count):
			dots += "."
			
		loading_label.text = "Loading" + dots

# ==========================================
# SCENE TRANSITION
# ==========================================
func _go_to_next_scene() -> void:
	# Look at the Global variable to see where the previous scene told us to go!
	if Global.target_scene != "":
		get_tree().change_scene_to_file(Global.target_scene)
	else:
		# Failsafe: If the variable is empty, don't crash. Return to main menu.
		print("ERROR: Global.target_scene is empty! Going to main menu as fallback.")
		get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")
