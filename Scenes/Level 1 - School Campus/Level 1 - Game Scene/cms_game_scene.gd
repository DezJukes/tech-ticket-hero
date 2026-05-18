extends Node2D

#OnReady Variables
@onready var pause_panel = %PausePanel
@onready var dashed_ring = $YSort/SchoolComputer/DashedRing
@onready var interaction_zone = $YSort/SchoolComputer/SchoolComputerInteractionZone

# Tracks the player's proximity state
var player_near_computer := false
var was_player_near := false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	# Store the current proximity state locally
	player_near_computer = interaction_zone.player_near
	
	# Enable/disable interact button based on proximity
	$CanvasLayer/Interact.disabled = not $YSort/SchoolComputer/SchoolComputerInteractionZone.player_near
	
	# Shows dash ring if the player is near the computer
	if player_near_computer != was_player_near:
		dashed_ring.set_active(player_near_computer)
		was_player_near = player_near_computer

# Shows pause menu
func _on_pause_button_pressed():
	get_tree().paused = true
	pause_panel.show()

# Player's interact button
func _on_interact_pressed() -> void:
	# Checks for proximity to able to use the interact button
	if interaction_zone.player_near:
		
		# 1. Tell the Global script where the loading screen should take us
		Global.target_scene = "res://Scenes/Level 1 - School Campus/Level 1 - Architecture/CMS_Architecture.tscn"
		
		# 2. Go to the Loading Screen!
		get_tree().change_scene_to_file("res://Scenes/Menu/Loading.tscn")
