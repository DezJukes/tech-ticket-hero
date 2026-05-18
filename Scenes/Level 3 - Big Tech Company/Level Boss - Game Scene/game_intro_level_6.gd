extends Node

# Intro Text UI
@onready var black_screen = $TITLE/Control/ColorRect
@onready var intro_info = $TITLE/Control/Label

# Dialogue UI
@onready var dialog_box = $TITLE/Control/Control/DialogueBox
@onready var name_label = $TITLE/Control/Control/DialogueBox/Label2
@onready var dialog_label = $TITLE/Control/Control/DialogueBox/Label3

# Objective UI
@onready var objective_banner = $"../CanvasLayer/Objective"
var final_objective_y: float

# --- Tap to continue system ---
signal screen_tapped
var waiting_for_tap: bool = false
var tap_received: bool = false
var continue_label: Label

# =========================
# NEW VARIABLES
# =========================

# Typing state
var is_typing: bool = false
var skip_typing: bool = false

# Speaker arrow
@onready var speaker_arrow = $TITLE/Control/Control/DialogueBox/SpeakerArrow

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
		
	# =========================
	# MUSIC PLAYER
	# =========================
	level_music_player = AudioStreamPlayer.new()
	level_music_player.stream = load("res://Assets/Audio/big-tech-music.mp3")
	level_music_player.bus = "Master"
	add_child(level_music_player)
	
	# =========================
	# CONTINUE LABEL
	# =========================
	continue_label = Label.new()

	continue_label.text = "Press screen to next ▶"

	continue_label.add_theme_font_size_override(
		"font_size",
		24
	)

	continue_label.set_anchors_preset(
		Control.PRESET_BOTTOM_RIGHT
	)

	continue_label.offset_left = -300
	continue_label.offset_top = -50

	continue_label.hide()

	$TITLE/Control.add_child(continue_label)
	
	# Pulse animation
	var pulse = create_tween().set_loops()

	pulse.tween_property(
		continue_label,
		"modulate:a",
		0.3,
		0.6
	)

	pulse.tween_property(
		continue_label,
		"modulate:a",
		1.0,
		0.6
	)

	# Bounce animation
	var bounce = create_tween().set_loops()

	bounce.tween_property(
		speaker_arrow,
		"position:y",
		15.0,
		0.4
	).as_relative()

	bounce.tween_property(
		speaker_arrow,
		"position:y",
		-15.0,
		0.4
	).as_relative()

	play_intro()


# =========================
# GLOBAL INPUT
# =========================
func _input(event: InputEvent) -> void:
	# Left click OR mobile tap
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed) or \
	   (event is InputEventScreenTouch and event.pressed):

		# Skip typewriter instantly
		if is_typing:
			skip_typing = true
			return

		# Continue dialogue
		if waiting_for_tap:
			tap_received = true


# =========================
# WAIT FOR USER
# =========================
func wait_for_user() -> void:
	waiting_for_tap = true
	
	tap_received = false

	continue_label.show()
	
	while not tap_received:
		await get_tree().process_frame
	
	continue_label.hide()

	waiting_for_tap = false


# =========================
# SPEAKER FUNCTION
# =========================
func set_speaker(speaker_name: String) -> void:
	name_label.text = speaker_name

	speaker_arrow.show()

	# Guard
	if speaker_name == "Boss":
		name_label.add_theme_color_override(
			"font_color",
			Color(1.0, 0.3, 0.3)
		)

		# Right side
		speaker_arrow.position = Vector2(608.0, -376.0)

	# Intern
	elif speaker_name == "Intern":
		name_label.add_theme_color_override(
			"font_color",
			Color(0.2, 0.7, 1.0)
		)

		# Left side
		speaker_arrow.position = Vector2(128.0, -376.0)


func play_intro() -> void:
	# =========================
	# INITIAL STATES
	# =========================
	black_screen.modulate.a = 1.0
	intro_info.modulate.a = 0.0
	
	dialog_box.modulate.a = 0.0
	dialog_label.modulate.a = 0.0
	name_label.modulate.a = 0.0

	# =========================
	# INTRO TEXT
	# =========================
	var t1 = create_tween()

	t1.tween_property(intro_info, "modulate:a", 1.0, 1.0)

	await t1.finished
	
	await wait_for_user()
	
	var t2 = create_tween()

	t2.set_parallel(true)

	t2.tween_property(intro_info, "modulate:a", 0.0, 1.0)
	t2.tween_property(black_screen, "modulate:a", 0.5, 1.0)

	await t2.finished
	
	# =========================
	# DIALOGUE PART
	# =========================
	var show_tween = create_tween()

	show_tween.set_parallel(true)

	show_tween.tween_property(
		dialog_box,
		"modulate:a",
		1.0,
		0.5
	)

	show_tween.tween_property(
		name_label,
		"modulate:a",
		1.0,
		0.5
	)

	show_tween.tween_property(
		dialog_label,
		"modulate:a",
		1.0,
		0.5
	)
	
	await show_tween.finished
	
	# Start level music
	level_music_player.play()
	
# =========================
	# DIALOGUE 1
	# =========================
	set_speaker("Boss")

	await type_text(
		dialog_label,
		"Congratulations, kid! You did well \nhandling that server issue downstairs.",
		0.03
	)

	await wait_for_user()
	
	# =========================
	# DIALOGUE 2
	# =========================
	set_speaker("Boss")

	await type_text(
		dialog_label,
		"You've proven yourself under pressure. \nBut now, it's time for the real test.",
		0.03
	)

	await wait_for_user()
	
	# =========================
	# DIALOGUE 3
	# =========================
	set_speaker("Boss")

	await type_text(
		dialog_label,
		"Our new Banking Architecture is a mess. \nTransactions are failing, and the \nledgers aren't syncing.",
		0.03
	)

	await wait_for_user()
	
	# =========================
	# DIALOGUE 4
	# =========================
	set_speaker("Intern")

	await type_text(
		dialog_label,
		"I can handle it, Sir! \nPoint me to the terminal.",
		0.03
	)

	await wait_for_user()

	# =========================
	# DIALOGUE 5
	# =========================
	set_speaker("Boss")

	await type_text(
		dialog_label,
		"That's what I like to hear. \nFix this banking system, and that \nfull-time developer position is yours.",
		0.03
	)

	await wait_for_user()
	
	# =========================
	# CLEAN EXIT
	# =========================
	speaker_arrow.hide()

	var end_tween = create_tween()

	end_tween.set_parallel(true)

	end_tween.tween_property(
		black_screen,
		"modulate:a",
		0.0,
		1.0
	)

	end_tween.tween_property(
		dialog_box,
		"modulate:a",
		0.0,
		0.5
	)

	end_tween.tween_property(
		name_label,
		"modulate:a",
		0.0,
		0.5
	)

	end_tween.tween_property(
		dialog_label,
		"modulate:a",
		0.0,
		0.5
	)
	
	await end_tween.finished
	
	# Remove intro UI completely
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
	if label == null:
		print("ERROR: dialog_label is NULL")
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
