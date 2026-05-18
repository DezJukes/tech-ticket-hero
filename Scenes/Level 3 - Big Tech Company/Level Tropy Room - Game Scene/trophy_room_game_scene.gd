extends Node2D

@onready var pause_panel = %PausePanel

# Grab the banner and the label inside it
@onready var achievement_banner = $CanvasLayer2/AchievementBanner
@onready var achievement_label = $CanvasLayer2/AchievementBanner/Label

var fade_tween: Tween

# ---------------------------------------------------
# INITIAL SETUP
# ---------------------------------------------------
func _ready() -> void:
	# Hide the banner instantly when the scene loads
	achievement_banner.modulate.a = 0.0

func _process(delta: float) -> void:
	pass

func _on_interact_pressed() -> void:
	pass # Add any interact logic here if needed later

func _on_pause_button_pressed() -> void:
	get_tree().paused = true
	pause_panel.show()

# ---------------------------------------------------
# ACHIEVEMENT BANNER ANIMATIONS
# ---------------------------------------------------
func show_achievement(text: String) -> void:
	achievement_label.text = text
	
	# Stop any current fading and fade IN
	if fade_tween:
		fade_tween.kill()
	fade_tween = create_tween()
	fade_tween.tween_property(achievement_banner, "modulate:a", 1.0, 0.3)

func hide_achievement() -> void:
	# Stop any current fading and fade OUT
	if fade_tween:
		fade_tween.kill()
	fade_tween = create_tween()
	fade_tween.tween_property(achievement_banner, "modulate:a", 0.0, 0.3)

# ---------------------------------------------------
# THE EXIT ZONE TRIGGER
# ---------------------------------------------------
func _on_exit_zone_body_entered(body: Node2D) -> void:
	if body.name == "player":
		# 1. Tell the Global script where the loading screen should take us
		Global.target_scene = "res://Scenes/Level 3 - Big Tech Company/Level Boss - Game Scene/Boss_game_scene.tscn"
		
		# 2. Go to the Loading Screen!
		get_tree().change_scene_to_file("res://Scenes/Menu/Loading.tscn")

# ---------------------------------------------------
# 1. NORMAL TROPHY (Left)
# ---------------------------------------------------
func _on_trophy_body_entered(body: Node2D) -> void:
	if body.name == "player":
		show_achievement("Level 1 Cleared: Mastered CMS Architecture!")

func _on_trophy_body_exited(body: Node2D) -> void:
	if body.name == "player":
		hide_achievement()

# ---------------------------------------------------
# 2. STAR TROPHY (Middle)
# ---------------------------------------------------
func _on_star_body_entered(body: Node2D) -> void:
	if body.name == "player":
		show_achievement("Level 2 Cleared: Deployed Enterprise Systems!")

func _on_star_body_exited(body: Node2D) -> void:
	if body.name == "player":
		hide_achievement()

# ---------------------------------------------------
# 3. CIRCLE TROPHY (Right)
# ---------------------------------------------------
func _on_circle_body_entered(body: Node2D) -> void:
	if body.name == "player":
		show_achievement("Level 3 Cleared: Secured Big Tech Banking!")

func _on_circle_body_exited(body: Node2D) -> void:
	if body.name == "player":
		hide_achievement()
