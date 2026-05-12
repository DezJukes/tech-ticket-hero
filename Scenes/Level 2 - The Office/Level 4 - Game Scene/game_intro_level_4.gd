extends Node

@onready var black_screen = $TITLE/Control/ColorRect
@onready var intro_text = $TITLE/Control/VBoxContainer

@onready var dialog_box = $TITLE/Control/Control/VBoxContainer2
@onready var name_label = $TITLE/Control/Control/Label2
@onready var dialog_label = $TITLE/Control/Control/Label3

# Objective UI
@onready var objective_banner = $"../CanvasLayer/Objective"
var final_objective_y: float

# --- NEW: Tap to continue system ---
signal screen_tapped
var waiting_for_tap: bool = false
var continue_label: Label

# --- MUSIC PLAYER ---
var level_music_player: AudioStreamPlayer

func _ready():
	# =========================
	# OBJECTIVE BANNER SETUP
	# =========================
	if objective_banner != null:
		final_objective_y = objective_banner.position.y
		
		# Hide above screen initially
		objective_banner.position.y = -150
		
	# Setup music player
	level_music_player = AudioStreamPlayer.new()
	level_music_player.stream = load("res://Assets/Audio/office-music.mp3")
	level_music_player.bus = "Master"
	add_child(level_music_player)
	
	# 1. Create the "Press screen" label entirely through code!
	continue_label = Label.new()
	continue_label.text = "Press screen to next ▶"
	continue_label.add_theme_font_size_override("font_size", 24)
	continue_label.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	continue_label.offset_left = -300 # Push it safely inward from the right edge
	continue_label.offset_top = -50   # Push it safely up from the bottom edge
	continue_label.hide()
	$TITLE/Control.add_child(continue_label)
	
	# 2. Add a simple looping pulse animation to the prompt
	var pulse = create_tween().set_loops()
	pulse.tween_property(continue_label, "modulate:a", 0.3, 0.6)
	pulse.tween_property(continue_label, "modulate:a", 1.0, 0.6)

	play_intro()

# --- NEW: Global Input Detection ---
func _input(event: InputEvent) -> void:
	# Check for a Left Mouse Click OR a Mobile Screen Tap
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed) or \
	   (event is InputEventScreenTouch and event.pressed):
		# If the game is currently paused waiting for the user, emit our signal to unpause it!
		if waiting_for_tap:
			screen_tapped.emit()

# --- NEW: Helper function to pause the sequence ---
func wait_for_user() -> void:
	waiting_for_tap = true
	continue_label.show() # Turn on the "Press screen" text
	
	await screen_tapped   # FREEZE the code here until the player taps
	
	continue_label.hide() # Hide it again when moving forward
	waiting_for_tap = false

func play_intro() -> void:
	# Initial states
	black_screen.modulate.a = 1.0
	intro_text.modulate.a = 0.0
	
	dialog_box.modulate.a = 0.0
	dialog_label.modulate.a = 0.0
	name_label.modulate.a = 0.0

	# --- INTRO TEXT ---
	var t1 = create_tween()
	t1.tween_property(intro_text, "modulate:a", 1.0, 1.0)
	await t1.finished
	
	# Pause code until the player taps!
	await wait_for_user()
	
	var t2 = create_tween()
	t2.tween_property(intro_text, "modulate:a", 0.0, 1.0)
	t2.tween_property(black_screen, "modulate:a", 0.5, 1.0)
	await t2.finished
	
	# =========================
	# DIALOGUE PART
	# =========================
	
	# Show dialog UI smoothly
	var show_tween = create_tween()
	show_tween.set_parallel(true) # Fade all 3 UI pieces in at the exact same time
	show_tween.tween_property(dialog_box, "modulate:a", 1.0, 0.5)
	show_tween.tween_property(name_label, "modulate:a", 1.0, 0.5)
	show_tween.tween_property(dialog_label, "modulate:a", 1.0, 0.5)
	
	await show_tween.finished
	
	# Start level music as dialogue begins
	level_music_player.play()
	
	# --- CONVERSATION START ---
	
	# Leader speaks
	name_label.text = "Leader"
	await type_text(dialog_label, "Wow! Did you do that by yourself?", 0.03)
	await wait_for_user() 
	
	# Intern replies
	name_label.text = "Intern"
	await type_text(dialog_label, "I did, sir.", 0.03)
	await wait_for_user() 
	
	# Leader speaks again
	name_label.text = "Leader"
	await type_text(dialog_label, "You're good at this, go to my office later on.", 0.03)
	await wait_for_user() 
	
	# Leader continues
	await type_text(dialog_label, "We have this E-Commerce System, do you \nmind fixing it?", 0.03)
	await wait_for_user() 
	
	# Intern final reply
	name_label.text = "Intern"
	await type_text(dialog_label, "Yes, sir, I can.", 0.03)
	await wait_for_user() 
	
	# End sequence, destroy title
	$TITLE.queue_free()
	
	# =========================
	# OBJECTIVE BANNER ANIMATION
	# =========================
	if objective_banner != null:
		var objective_tween = create_tween()

		objective_tween.set_trans(Tween.TRANS_QUART)
		objective_tween.set_ease(Tween.EASE_OUT)

		objective_tween.tween_property(
			objective_banner,
			"position:y",
			final_objective_y,
			0.8
		)

# =========================
# TYPEWRITER EFFECT
# =========================
func type_text(label: Label, text: String, speed := 0.03) -> void:
	label.text = ""
	
	for i in text.length():
		label.text += text[i]
		await get_tree().create_timer(speed).timeout
