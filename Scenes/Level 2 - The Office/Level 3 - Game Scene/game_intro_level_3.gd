extends Node

@onready var black_screen = $TITLE/Control/ColorRect
@onready var intro_text = $TITLE/Control/VBoxContainer
@onready var intro_info = $TITLE/Control/Label

# Dialogue UI
@onready var dialog_box = $TITLE/Control/Control/VBoxContainer2
@onready var name_label = $TITLE/Control/Control/Label2
@onready var dialog_label = $TITLE/Control/Control/Label3

# Objective UI
@onready var objective_banner = $"../CanvasLayer/Objective"
var final_objective_y: float

# --- Tap to continue system ---
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

	# =========================
	# MUSIC SETUP
	# =========================
	level_music_player = AudioStreamPlayer.new()
	level_music_player.stream = load("res://Assets/Audio/office-music.mp3")
	level_music_player.bus = "Master"
	add_child(level_music_player)

	# =========================
	# PRESS SCREEN LABEL
	# =========================
	continue_label = Label.new()
	continue_label.text = "Press screen to next ▶"
	continue_label.add_theme_font_size_override("font_size", 24)

	continue_label.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)

	continue_label.offset_left = -300
	continue_label.offset_top = -50

	continue_label.hide()

	$TITLE/Control.add_child(continue_label)

	# Pulse animation
	var pulse = create_tween().set_loops()

	pulse.tween_property(continue_label, "modulate:a", 0.3, 0.6)
	pulse.tween_property(continue_label, "modulate:a", 1.0, 0.6)

	play_intro()


# =========================
# GLOBAL INPUT
# =========================
func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed) or \
	   (event is InputEventScreenTouch and event.pressed):

		if waiting_for_tap:
			screen_tapped.emit()


# =========================
# WAIT FOR USER
# =========================
func wait_for_user() -> void:
	waiting_for_tap = true

	continue_label.show()

	await screen_tapped

	continue_label.hide()

	waiting_for_tap = false


# =========================
# INTRO SEQUENCE
# =========================
func play_intro() -> void:
	# Initial states
	black_screen.modulate.a = 1.0
	intro_text.modulate.a = 0.0
	intro_info.modulate.a = 0.0

	dialog_box.modulate.a = 0.0
	dialog_label.modulate.a = 0.0
	name_label.modulate.a = 0.0

	# =========================
	# FIRST TEXT
	# =========================
	var t1 = create_tween()

	t1.tween_property(intro_info, "modulate:a", 1.0, 1.0)

	await t1.finished
	await wait_for_user()

	var t2 = create_tween()

	t2.tween_property(intro_info, "modulate:a", 0.0, 0.8)

	await t2.finished

	# =========================
	# SECOND TEXT
	# =========================
	var t3 = create_tween()

	t3.tween_property(intro_text, "modulate:a", 1.0, 1.0)

	await t3.finished
	await wait_for_user()

	var t4 = create_tween()

	t4.set_parallel(true)

	t4.tween_property(intro_text, "modulate:a", 0.0, 1.0)
	t4.tween_property(black_screen, "modulate:a", 0.5, 1.0)

	await t4.finished

	# =========================
	# DIALOGUE PART
	# =========================
	var show_tween = create_tween()

	show_tween.set_parallel(true)

	show_tween.tween_property(dialog_box, "modulate:a", 1.0, 0.5)
	show_tween.tween_property(name_label, "modulate:a", 1.0, 0.5)
	show_tween.tween_property(dialog_label, "modulate:a", 1.0, 0.5)

	await show_tween.finished

	# Start level music
	level_music_player.play()

	name_label.text = "Juan"

	# =========================
	# DIALOGUE 1
	# =========================
	await type_text(dialog_label, "Oh no! One of the computers is alerting.", 0.03)
	await wait_for_user()

	# =========================
	# DIALOGUE 2
	# =========================
	await type_text(dialog_label, "I should maybe check it out.", 0.03)
	await wait_for_user()

	# =========================
	# CLEAN EXIT
	# =========================
	var end_tween = create_tween()

	end_tween.set_parallel(true)

	end_tween.tween_property(black_screen, "modulate:a", 0.0, 1.0)
	end_tween.tween_property(dialog_box, "modulate:a", 0.0, 0.5)
	end_tween.tween_property(name_label, "modulate:a", 0.0, 0.5)
	end_tween.tween_property(dialog_label, "modulate:a", 0.0, 0.5)

	await end_tween.finished

	# Remove intro overlay
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
