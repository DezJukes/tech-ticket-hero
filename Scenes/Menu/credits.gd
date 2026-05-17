extends Control

# --- SCENE NODES ---
@onready var logo = $Logo
@onready var credit_label = $CreditLabel

# --- THE CREDITS LIST ---
var team_credits = [
	"LEAD PROGRAMMER\nYour Name",
	"UI & VISUAL NOVEL\nGroupmate 1",
	"GAME DESIGNER\nGroupmate 2",
	"SPECIAL THANKS\nOur Professor",
	"Thank you for playing!"
]

# --- STATE TRACKING ---
var current_index: int = -1
var active_tween: Tween
var phase: String = "LOGO" # Can be "LOGO", "CREDITS", or "DONE"

func _ready() -> void:
	# Hide everything instantly when the scene loads
	logo.modulate.a = 0.0
	credit_label.modulate.a = 0.0
	
	# Start the logo fade
	_play_logo()


func _play_logo() -> void:
	phase = "LOGO"
	active_tween = create_tween()
	active_tween.tween_property(logo, "modulate:a", 1.0, 0.8)
	active_tween.tween_interval(1.5)
	active_tween.tween_property(logo, "modulate:a", 0.0, 0.8)
	
	# When the animation finishes naturally, go to the next credit
	active_tween.finished.connect(_show_next_credit)


func _show_next_credit() -> void:
	phase = "CREDITS"
	current_index += 1
	
	# Hide the logo instantly just in case the player skipped the logo phase
	logo.modulate.a = 0.0
	
	# If we reached the end of the list, go to the main menu!
	if current_index >= team_credits.size():
		_go_to_main_menu()
		return
		
	# Instantly hide the old text and set the new text
	credit_label.modulate.a = 0.0
	credit_label.text = team_credits[current_index]
	
	# Animate the new text
	active_tween = create_tween()
	active_tween.tween_property(credit_label, "modulate:a", 1.0, 0.5)
	active_tween.tween_interval(1.2)
	active_tween.tween_property(credit_label, "modulate:a", 0.0, 0.5)
	
	# When this specific text finishes fading out, loop back to this same function
	active_tween.finished.connect(_show_next_credit)


# =========================
# GLOBAL INPUT (TAP TO NEXT)
# =========================
func _input(event: InputEvent) -> void:
	# Left click OR mobile tap
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed) or \
	   (event is InputEventScreenTouch and event.pressed):
		
		# Don't do anything if we are already transitioning back to the menu
		if phase == "DONE":
			return
			
		# Stop whatever animation is currently happening
		if active_tween:
			active_tween.kill()
			
		# Instantly jump to the next item!
		_show_next_credit()


func _go_to_main_menu() -> void:
	phase = "DONE"
	print("Credits completely finished!")
	get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")
