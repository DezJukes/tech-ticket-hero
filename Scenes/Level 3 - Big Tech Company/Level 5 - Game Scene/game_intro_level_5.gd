extends Node
@onready var black_screen = $TITLE/Control/ColorRect
@onready var intro_text = $TITLE/Control/VBoxContainer

@onready var dialog_box = $TITLE/Control/VBoxContainer2
@onready var name_label = $TITLE/Control/Label2
@onready var dialog_label = $TITLE/Control/Label3

func _ready():
	play_intro()

func play_intro() -> void:
	# Initial states
	black_screen.modulate.a = 1.0
	intro_text.modulate.a = 0.0
	
	dialog_box.modulate.a = 0.0
	dialog_label.modulate.a = 0.0
	name_label.modulate.a = 0.0

	var tween = create_tween()
	
	# --- INTRO TEXT ---
	tween.tween_property(intro_text, "modulate:a", 1.0, 1.0)
	tween.tween_interval(1.5)
	tween.tween_property(intro_text, "modulate:a", 0.0, 1.0)
	
	# Fade to semi-transparent instead of disappearing
	tween.tween_property(black_screen, "modulate:a", 0.5, 1.0)
	
	await tween.finished
	
	# =========================
	# DIALOGUE PART
	# =========================
	
	# Show dialog UI
	var show_tween = create_tween()
	show_tween.tween_property(dialog_box, "modulate:a", 1.0, 0.5)
	show_tween.tween_property(name_label, "modulate:a", 1.0, 0.5)
	show_tween.tween_property(dialog_label, "modulate:a", 1.0, 0.5)
	
	await show_tween.finished
	
	name_label.text = "Guard"
	
	await type_text(dialog_label, "Bawal dito hindi marunong mag code!", 0.03)
	await get_tree().create_timer(1.0).timeout
	
	await type_text(dialog_label, "Patunayan mo muna na kaya mo.", 0.03)
	await get_tree().create_timer(1.0).timeout
	
	await type_text(dialog_label, "Ayusin mo tong system namin!", 0.03)
	await get_tree().create_timer(1.0).timeout
	
	
	# =========================
	# CLEAN EXIT (IMPORTANT)
	# =========================
	
	# Fade everything out so next scene is NOT black
	var end_tween = create_tween()
	end_tween.tween_property(black_screen, "modulate:a", 0.0, 1.0)
	end_tween.tween_property(dialog_box, "modulate:a", 0.0, 0.5)
	end_tween.tween_property(name_label, "modulate:a", 0.0, 0.5)
	end_tween.tween_property(dialog_label, "modulate:a", 0.0, 0.5)
	
	await end_tween.finished
	
	# Remove intro UI completely
	$TITLE.queue_free()


# =========================
# TYPEWRITER EFFECT
# =========================
func type_text(label: Label, text: String, speed := 0.03) -> void:
	if label == null:
		print("ERROR: dialog_label is NULL")
		return
	
	label.text = ""
	
	for i in text.length():
		label.text += text[i]
		await get_tree().create_timer(speed).timeout
