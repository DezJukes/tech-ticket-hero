extends Node2D

# Initialize
@onready var pause_panel = %PausePanel
@onready var dashed_ring = $Guard/DashedRing
@onready var interaction_zone = $Guard/SchoolComputerInteractionZone
var player_near_computer := false
var was_player_near := false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	# Validate if player is near the computer
	player_near_computer = interaction_zone.player_near
	$CanvasLayer/Interact.disabled = not $Guard/SchoolComputerInteractionZone.player_near
	
	if player_near_computer != was_player_near:
		dashed_ring.set_active(player_near_computer)
		was_player_near = player_near_computer

# Process interact
func _on_interact_pressed() -> void:
	# Checks for proximity to able to use the interact button
	if interaction_zone.player_near:
		
		# 1. Tell the Global script where the loading screen should take us
		Global.target_scene = "res://Scenes/Level 3 - Big Tech Company/Level Tropy Room - Game Scene/TrophyRoom_game_scene.tscn"
		
		# 2. Go to the Loading Screen!
		get_tree().change_scene_to_file("res://Scenes/Menu/Loading.tscn")
		
	

func _on_pause_button_pressed() -> void:
	get_tree().paused = true
	pause_panel.show()
