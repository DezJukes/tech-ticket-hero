extends Node

# Intro UI
@onready var black_screen = $TITLE/Control/ColorRect
@onready var intro_text = $TITLE/Control/VBoxContainer
@onready var intro_info = $TITLE/Control/Label

# Dialogue UI
@onready var dialog_box = $TITLE/Control/DialogueBox
@onready var name_label = $TITLE/Control/DialogueBox/Label2
@onready var dialog_label = $TITLE/Control/DialogueBox/Label3

# Objective UI
@onready var objective_banner = $"../CanvasLayer/Objective"
var final_objective_y: float

# --- Tap to continue system ---
signal screen_tapped
var waiting_for_tap: bool = false
var tap_received: bool = false
var continue_label: Label

# Typing state
var is_typing: bool = false
var skip_typing: bool = false

# --- NEW: Bouncing Arrow Indicator ---
@onready var speaker_arrow = $TITLE/Control/DialogueBox/SpeakerArrow

# --- MUSIC PLAYER ---
var level_music_player: AudioStreamPlayer

func _ready():
	if objective_banner != null:
		final_objective_y = objective_banner.position.y
		objective_banner.position.y = -150
		
	# Setup music player
	level_music_player = AudioStreamPlayer.new()
	level_music_player.stream = load("res://Assets/Audio/campus-music.mp3")
	level_music_player.bus = "Master"
	add_child(level_music_player)
	
	# 1. Create the "Press screen" prompt
	continue_label = Label.new()
	continue_label.text = "Press screen to next ▶"
	continue_label.add_theme_font_size_override("font_size", 24)
	continue_label.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	continue_label.offset_left = -300 
	continue_label.offset_top = -50   
	continue_label.hide()
	$TITLE/Control.add_child(continue_label)
	
	var pulse = create_tween().set_loops()
	pulse.tween_property(continue_label, "modulate:a", 0.3, 0.6)
	pulse.tween_property(continue_label, "modulate:a", 1.0, 0.6)
	
	# Make the arrow bounce up and down forever
	var bounce = create_tween().set_loops()
	bounce.tween_property(speaker_arrow, "position:y", 15.0, 0.4).as_relative()
	bounce.tween_property(speaker_arrow, "position:y", -15.0, 0.4).as_relative()

	play_intro()

# --- Global Input Detection ---
func _input(event: InputEvent) -> void:
	# Check for screen touch
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed) or \
	   (event is InputEventScreenTouch and event.pressed):
		
		# If text is currently typing, tapping skips the animation
		if is_typing:
			skip_typing = true
			return
		
		# If text is done and waiting for input, tapping registers the continuation
		if waiting_for_tap:
			tap_received = true

# Pause execution until user taps the screen
func wait_for_user() -> void:
	waiting_for_tap = true
	tap_received = false
	continue_label.show() 
	
	while not tap_received:
		await get_tree().process_frame

	continue_label.hide() 
	waiting_for_tap = false
	tap_received = false

# Updates the UI to reflect who is currently speaking
func set_speaker(speaker_name: String) -> void:
	name_label.text = speaker_name
	speaker_arrow.show()
	
	if speaker_name == "Student":
		name_label.add_theme_color_override("font_color", Color(0.2, 0.6, 1.0)) # Blue text
		speaker_arrow.position = Vector2(128.0, -376.0) # Left side of screen
	elif speaker_name == "Professor":
		name_label.add_theme_color_override("font_color", Color(0.7, 0.3, 1.0)) # Purple text
		speaker_arrow.position = Vector2(608.0, -376.0) # Right side of screen

func play_intro() -> void:
	black_screen.modulate.a = 1.0
	intro_text.modulate.a = 0.0
	intro_info.modulate.a = 0.0
	dialog_box.modulate.a = 0.0
	dialog_label.modulate.a = 0.0
	name_label.modulate.a = 0.0

	var t1 = create_tween()
	t1.tween_property(intro_info, "modulate:a", 1.0, 1.0)
	await t1.finished
	await wait_for_user() 
	
	var t2 = create_tween()
	t2.tween_property(intro_info, "modulate:a", 0.0, 0.8)
	await t2.finished
	
	var t3 = create_tween()
	t3.tween_property(intro_text, "modulate:a", 1.0, 1.0)
	await t3.finished
	await wait_for_user() 
	
	var t4 = create_tween()
	t4.set_parallel(true)
	t4.tween_property(intro_text, "modulate:a", 0.0, 1.0)
	t4.tween_property(black_screen, "modulate:a", 0.5, 1.5) 
	await t4.finished
	
	# Show dialog UI smoothly
	var show_tween = create_tween()
	show_tween.set_parallel(true) 
	show_tween.tween_property(dialog_box, "modulate:a", 1.0, 0.5)
	show_tween.tween_property(name_label, "modulate:a", 1.0, 0.5)
	show_tween.tween_property(dialog_label, "modulate:a", 1.0, 0.5)
	await show_tween.finished
	
	# Start level music as dialogue begins
	level_music_player.play()
	
	# --- CONVERSATION START ---
	
	set_speaker("Professor")
	await type_text(dialog_label, "Excellent work on the CMS architecture! You \nmapped those components perfectly.", 0.03)
	await wait_for_user() 
	
	set_speaker("Student")
	await type_text(dialog_label, "Thank you, Professor. It took some trial and \nerror, but I got the data flowing.", 0.03)
	await wait_for_user() 
	
	set_speaker("Professor")
	await type_text(dialog_label, "Since you handled that so well, I have a real \nworld problem for you.", 0.03)
	await wait_for_user() 
	
	await type_text(dialog_label, "Our digital library system is bottlenecking. I \nneed you to restructure it.", 0.03)
	await wait_for_user() 
	
	set_speaker("Student")
	await type_text(dialog_label, "Absolutely. Let me take a look at the blueprint \nright now.", 0.03)
	await wait_for_user() 
	
	# =========================
	# CLEAN EXIT
	# =========================
	
	speaker_arrow.hide() # Hide the arrow!
	
	var end_tween = create_tween()
	end_tween.set_parallel(true) 
	end_tween.tween_property(black_screen, "modulate:a", 0.0, 1.0)
	end_tween.tween_property(dialog_box, "modulate:a", 0.0, 0.5)
	end_tween.tween_property(name_label, "modulate:a", 0.0, 0.5)
	end_tween.tween_property(dialog_label, "modulate:a", 0.0, 0.5)
	
	await end_tween.finished
	
	$TITLE.queue_free()
	
	# Slide in objective banner
	if objective_banner != null:
		var objective_tween = create_tween()

		objective_tween.set_trans(Tween.TRANS_QUART)
		objective_tween.set_ease(Tween.EASE_OUT)
		objective_tween.tween_property(objective_banner, "position:y", final_objective_y, 0.8)

# Animates text character by character onto a label.
func type_text(label: Label, text: String, speed := 0.03) -> void:
	if label == null:
		return

	label.text = ""
	is_typing = true
	skip_typing = false

	for i in text.length():
		if skip_typing:
			label.text = text
			break

		label.text += text[i]
		await get_tree().create_timer(speed).timeout
	
	is_typing = false
