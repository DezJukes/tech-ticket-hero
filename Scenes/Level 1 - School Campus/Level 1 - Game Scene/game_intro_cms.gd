extends Node

# Intro UI
@onready var black_screen = $TITLE/Control/ColorRect
@onready var intro_text = $TITLE/Control/VBoxContainer
@onready var intro_info = $TITLE/Control/Label

# Dialogue UI
@onready var dialog_box = $TITLE/Control/VBoxContainer2
@onready var name_label = $TITLE/Control/Label2
@onready var dialog_label = $TITLE/Control/Label3

# Objective UI
@onready var objective_banner = $"../CanvasLayer/Objective"
var final_objective_y: float

# --- Tap to continue system ---
signal screen_tapped
var waiting_for_tap: bool = false
var continue_label: Label

# --- NEW: Bouncing Arrow Indicator ---
var speaker_arrow: Label

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

	# 2. Create the floating "Who is speaking" arrow!
	speaker_arrow = Label.new()
	speaker_arrow.text = "▼"
	speaker_arrow.add_theme_font_size_override("font_size", 60)
	speaker_arrow.add_theme_color_override("font_color", Color(1.0, 0.8, 0.0)) # Gold/Yellow
	speaker_arrow.add_theme_color_override("font_outline_color", Color(0,0,0))
	speaker_arrow.add_theme_constant_override("outline_size", 8)
	speaker_arrow.hide()
	$TITLE/Control.add_child(speaker_arrow)
	
	# Make the arrow bounce up and down forever
	var bounce = create_tween().set_loops()
	bounce.tween_property(speaker_arrow, "position:y", 15.0, 0.4).as_relative()
	bounce.tween_property(speaker_arrow, "position:y", -15.0, 0.4).as_relative()

	play_intro()

# --- Global Input Detection ---
func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed) or \
	   (event is InputEventScreenTouch and event.pressed):
		if waiting_for_tap:
			screen_tapped.emit()

func wait_for_user() -> void:
	waiting_for_tap = true
	continue_label.show() 
	await screen_tapped   
	continue_label.hide() 
	waiting_for_tap = false

# --- Helper function to switch speakers ---
func set_speaker(speaker_name: String) -> void:
	name_label.text = speaker_name
	speaker_arrow.show()
	
	# Move the arrow and change the name color based on who is talking!
	# NOTE: You may need to tweak the "x" and "y" pixel numbers below to 
	# make the arrow point exactly at their heads on your specific screen size!
	if speaker_name == "Student":
		name_label.add_theme_color_override("font_color", Color(0.2, 0.6, 1.0)) # Blue text
		speaker_arrow.position = Vector2(300, 150) # Left side of screen
	elif speaker_name == "Professor":
		name_label.add_theme_color_override("font_color", Color(0.7, 0.3, 1.0)) # Purple text
		speaker_arrow.position = Vector2(800, 150) # Right side of screen

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
	
	# --- CONVERSATION START (CMS ARCHITECTURE) ---
	
	set_speaker("Professor")
	await type_text(dialog_label, "Attention! We have an urgent CMS architecture \nactivity that needs your immediate focus.", 0.03)
	await wait_for_user() 
	
	set_speaker("Student")
	await type_text(dialog_label, "I'm ready, Professor. What kind of Content \nManagement System are we building?", 0.03)
	await wait_for_user() 
	
	set_speaker("Professor")
	await type_text(dialog_label, "The CMS has no Authentication and search \nengine we need those for content.", 0.03)
	await wait_for_user() 
	
	await type_text(dialog_label, "Implement this immediately. It will be a great \ntest of your system design skills.", 0.03)
	await wait_for_user() 
	
	set_speaker("Student")
	await type_text(dialog_label, "Understood! I'll map out the components and \nget the data flowing right away.", 0.03)
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

func type_text(label: Label, text: String, speed := 0.03) -> void:
	if label == null:
		return
	label.text = ""
	for i in text.length():
		label.text += text[i]
		await get_tree().create_timer(speed).timeout
