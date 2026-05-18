extends Control

# --- SCENE NODES ---
@onready var character = $Character
@onready var character2 = $Character2
@onready var character3 = $Character3
@onready var dialogue_label = $Dialogue
@onready var tap_indicator = $TapIndicator

# --- THE ENDING STORY ---
var story_lines: Array[String] = [
	"From fixing routing gateways to deploying the entire banking architecture...",
	"It was a challenging journey, but I didn't do it alone.", # <--- Mentors will slide in here!
	"With the guidance of my mentors, every bug fixed was a lesson learned.",
	"My ID badge doesn't say 'Intern' anymore.",
	"Today, I step into the office as a Full-Time Developer."
]

# --- STATE TRACKING ---
var current_line: int = 0
var active_tween: Tween
var text_tween: Tween
var phase: String = "SETUP" # Can be: SLIDING, TYPING, WAITING, FINALE
var mentors_revealed: bool = false

# Initial target positions
var character_target_x: float
var char2_target_x: float
var char3_target_x: float

func _ready() -> void:
	# Hide the tap indicator initially
	tap_indicator.visible = false
	
	# Save target positions
	character_target_x = character.position.x
	char2_target_x = character2.position.x
	char3_target_x = character3.position.x
	
	# Move characters off-screen for the slide-in effect
	character.position.x = character_target_x - 300
	character2.position.x = char2_target_x - 300 # Left side
	character3.position.x = char3_target_x + 300 # Right side
	
	# Start with everything invisible
	character.modulate.a = 0.0
	character2.modulate.a = 0.0
	character3.modulate.a = 0.0
	dialogue_label.modulate.a = 0.0
	
	# Start the cinematic slide-in for the main character
	_slide_in_character()


func _slide_in_character() -> void:
	phase = "SLIDING"
	active_tween = create_tween()
	
	# Slide in Character (Main Intern)
	active_tween.tween_property(character, "position:x", character_target_x, 1.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	active_tween.parallel().tween_property(character, "modulate:a", 1.0, 1.5)
	
	active_tween.tween_interval(0.5)
	active_tween.finished.connect(_show_next_line)


func _slide_in_mentors() -> void:
	mentors_revealed = true
	var mentor_tween = create_tween()
	
	# Character 2 (Boss) slides in from left
	mentor_tween.parallel().tween_property(character2, "position:x", char2_target_x, 1.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	mentor_tween.parallel().tween_property(character2, "modulate:a", 1.0, 1.5)
	
	# Character 3 (Coworker) slides in from right
	mentor_tween.parallel().tween_property(character3, "position:x", char3_target_x, 1.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	mentor_tween.parallel().tween_property(character3, "modulate:a", 1.0, 1.5)


func _show_next_line() -> void:
	# Hide the indicator whenever a new line starts typing
	tap_indicator.visible = false
	
	# If we finished all story lines, show the finale
	if current_line >= story_lines.size():
		_show_finale()
		return
		
	phase = "TYPING"
	
	# ---> CHECK IF WE SHOULD REVEAL MENTORS <---
	# If we hit line index 1 ("I didn't do it alone"), trigger the mentors!
	if current_line == 1 and not mentors_revealed:
		_slide_in_mentors()
	
	# Set up the text and hide the characters so we can tween them
	dialogue_label.modulate.a = 1.0
	dialogue_label.text = story_lines[current_line]
	dialogue_label.visible_characters = 0 
	
	# Calculate typing speed (0.03 seconds per letter)
	var typing_duration = story_lines[current_line].length() * 0.03
	
	if text_tween:
		text_tween.kill()
	text_tween = create_tween()
	
	# Animate the characters appearing one by one (The Typing Effect)
	text_tween.tween_property(dialogue_label, "visible_characters", story_lines[current_line].length(), typing_duration)
	text_tween.finished.connect(_on_typing_finished)


func _on_typing_finished() -> void:
	phase = "WAITING"
	dialogue_label.visible_characters = -1 # Ensure all text is fully shown
	
	# Show the indicator in the lower right now that typing is done!
	tap_indicator.visible = true


func _show_finale() -> void:
	phase = "FINALE" # Tapping does nothing now! Let the cinematic play.
	tap_indicator.visible = false 
	
	if text_tween: text_tween.kill()
	if active_tween: active_tween.kill()
	
	var finale_tween = create_tween()
	
	# Fade out the last line of dialogue
	finale_tween.tween_property(dialogue_label, "modulate:a", 0.0, 0.5)
	
	# Swap the text to Game Complete
	finale_tween.tween_callback(func(): 
		dialogue_label.text = "GAME COMPLETE"
		dialogue_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER 
	)
	
	# Fade the GAME COMPLETE text back in
	finale_tween.tween_property(dialogue_label, "modulate:a", 1.0, 1.5)
	
	# Linger on "GAME COMPLETE" and the team so they can feel proud
	finale_tween.tween_interval(4.0)
	
	# Smoothly fade the ENTIRE scene to black (or clear) before swapping to credits
	finale_tween.tween_property(self, "modulate:a", 0.0, 1.5)
	
	finale_tween.finished.connect(_go_to_credits)


# =========================
# GLOBAL INPUT (VN CONTROLS)
# =========================
func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed) or \
	   (event is InputEventScreenTouch and event.pressed):
		
		# If the game is finishing, OR if the text is currently typing, ignore the tap!
		if phase == "FINALE" or phase == "TYPING":
			return
			
		# Skip the initial sliding animation for the main character
		if phase == "SLIDING":
			if active_tween: active_tween.kill()
			character.position.x = character_target_x
			character.modulate.a = 1.0
			_show_next_line()
			
		# Proceed to the next line only when it is completely done typing
		elif phase == "WAITING":
			current_line += 1
			_show_next_line()


func _go_to_credits() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu/Credits.tscn")
