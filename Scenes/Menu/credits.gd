extends Control

# --- SCENE NODES ---
@onready var logo = $Logo
@onready var credit_label = $CreditLabel

# --- AUDIO ---
var menu_music_player: AudioStreamPlayer

# --- THE CREDITS LIST ---
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
var is_showing_logo: bool = true
var transitioning: bool = false


func _ready() -> void:
	# Hide everything instantly when the scene loads
	logo.modulate.a = 0.0
	credit_label.modulate.a = 0.0
	
	# Enable input
	set_process_input(true)
	
	# =========================================
	# SETUP CREDITS MUSIC
	# =========================================
	menu_music_player = AudioStreamPlayer.new()
	menu_music_player.stream = load("res://Assets/Audio/menu-music.mp3")
	menu_music_player.bus = "Master"
	menu_music_player.volume_db = -5
	add_child(menu_music_player)
	menu_music_player.play()
	
	# Start logo animation
	_play_logo()


# =========================================
# INPUT HANDLER
# Click / Space / Enter skips to next credit
# =========================================
func _input(event: InputEvent) -> void:
	if event.is_pressed():
		
		# Mouse click
		if event is InputEventMouseButton:
			_skip_to_next()
		
		# Keyboard
		elif event.is_action_pressed("ui_accept"):
			_skip_to_next()


func _skip_to_next() -> void:
	# Prevent spam clicking
	if transitioning:
		return
	
	transitioning = true
	
	# Stop current animation safely
	if active_tween:
		active_tween.kill()
	
	# If logo is currently showing
	if is_showing_logo:
		logo.modulate.a = 0.0
		is_showing_logo = false
		transitioning = false
		_show_next_credit()
		return
	
	# Skip current credit
	credit_label.modulate.a = 0.0
	transitioning = false
	_show_next_credit()


# =========================================
# LOGO SEQUENCE
# =========================================
func _play_logo() -> void:
	is_showing_logo = true
	
	active_tween = create_tween()
	
	active_tween.tween_property(logo, "modulate:a", 1.0, 1.5)
	active_tween.tween_interval(2.0)
	active_tween.tween_property(logo, "modulate:a", 0.0, 1.5)
	
	active_tween.finished.connect(func():
		is_showing_logo = false
		_show_next_credit()
	)


# =========================================
# CREDIT DISPLAY
# =========================================
func _show_next_credit() -> void:
	current_index += 1
	
	# End credits
	if current_index >= team_credits.size():
		_go_to_main_menu()
		return
	
	# Set new text
	credit_label.modulate.a = 0.0
	credit_label.text = team_credits[current_index]
	
	# Animate text
	active_tween = create_tween()
	
	active_tween.tween_property(
		credit_label,
		"modulate:a",
		1.0,
		0.8
	)
	
	active_tween.tween_interval(1.5)
	
	active_tween.tween_property(
		credit_label,
		"modulate:a",
		0.0,
		0.8
	)
	
	active_tween.finished.connect(_show_next_credit)


# =========================================
# MAIN MENU
# =========================================
func _go_to_main_menu() -> void:
	print("Credits completely finished!")
	
	# Stop music before leaving
	if menu_music_player:
		menu_music_player.stop()
	
	get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")
