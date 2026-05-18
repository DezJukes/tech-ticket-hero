extends Control

# --- SCENE NODES ---
@onready var logo = $Logo
@onready var credit_label = $CreditLabel

# --- THE CREDITS LIST (Enhanced Formatting) ---
var team_credits: Array[String] = [
	"[center][color=#a1a1aa][font_size=24]PROJECT MANAGER & LEAD GAME DEVELOPER[/font_size][/color]\n[font_size=40]EMMAN MANDURIAGA[/font_size][/center]",
	"[center][color=#a1a1aa][font_size=24]GAME DESIGNER & VISUAL NOVEL[/font_size][/color]\n[font_size=40]DAN ATENCIA[/font_size][/center]",
	"[center][color=#a1a1aa][font_size=24]ARCHITECTURE & COMPONENT DESIGNER[/font_size][/color]\n[font_size=40]MIRACLE JOY AMPER[/font_size][/center]",
	"[center][color=#a1a1aa][font_size=24]LEAD GAME DOCUMENTATION[/font_size][/color]\n[font_size=40]MIRACLE JOY AMPER[/font_size][/center]",
	"[center][color=#a1a1aa][font_size=24]GAME DEVELOPER[/font_size][/color]\n[font_size=40]JOHN BRYAN DELA CRUZ[/font_size][/center]",
	"[center][color=#a1a1aa][font_size=24]COMPONENT DESIGNER[/font_size][/color]\n[font_size=40]JENNY JIMENEZ[/font_size][/center]",
	"[center][color=#a1a1aa][font_size=24]GAME DOCUMENTATION[/font_size][/color]\n[font_size=40]JENNY JIMENEZ[/font_size][/center]",
	"[center][color=#a1a1aa][font_size=24]GAME DEVELOPER[/font_size][/color]\n[font_size=40]AUGUSTINE BRAIN SABORDIO[/font_size][/center]",
	"[center][color=#3b82f6][font_size=32]Thank you for playing![/font_size][/color][/center]"
]

# --- STATE TRACKING ---
var current_index: int = -1
var active_tween: Tween

func _ready() -> void:
	# Hide everything instantly when the scene loads
	logo.modulate.a = 0.0
	credit_label.modulate.a = 0.0
	
	# Start the logo fade
	_play_logo()


func _play_logo() -> void:
	active_tween = create_tween()
	
	# Slower, cinematic fade for the logo
	active_tween.tween_property(logo, "modulate:a", 1.0, 1.5)
	active_tween.tween_interval(2.0)
	active_tween.tween_property(logo, "modulate:a", 0.0, 1.5)
	
	# When the animation finishes naturally, go to the next credit
	active_tween.finished.connect(_show_next_credit)


func _show_next_credit() -> void:
	current_index += 1
	
	# If we reached the end of the list, go to the main menu!
	if current_index >= team_credits.size():
		_go_to_main_menu()
		return
		
	# Instantly hide the old text and set the new text
	credit_label.modulate.a = 0.0
	credit_label.text = team_credits[current_index]
	
	# Animate the new text
	active_tween = create_tween()
	active_tween.tween_property(credit_label, "modulate:a", 1.0, 0.8)  # Fade in
	active_tween.tween_interval(1.5)                                   # Hold on screen longer to read!
	active_tween.tween_property(credit_label, "modulate:a", 0.0, 0.8)  # Fade out
	
	# When this specific text finishes fading out, loop back to this same function
	active_tween.finished.connect(_show_next_credit)


func _go_to_main_menu() -> void:
	print("Credits completely finished!")
	get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")
