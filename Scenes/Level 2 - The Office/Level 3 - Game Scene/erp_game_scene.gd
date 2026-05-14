extends Node2D

@onready var pause_panel = %PausePanel
@onready var dashed_ring = $SchoolComputer/DashedRing
@onready var interaction_zone = $SchoolComputer/SchoolComputerInteractionZone
var player_near_computer := false
var was_player_near := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	player_near_computer = interaction_zone.player_near
	
	$CanvasLayer/Interact.disabled = not $SchoolComputer/SchoolComputerInteractionZone.player_near
	
	if player_near_computer != was_player_near:
		dashed_ring.set_active(player_near_computer)
		was_player_near = player_near_computer

func _on_interact_pressed() -> void:
	if $SchoolComputer/SchoolComputerInteractionZone.player_near:
		get_tree().change_scene_to_file("res://Scenes/Level 2 - The Office/Level 3 - Architecture/ERP_Architecture.tscn")
	else:
		print("You are too far from the computer to interact.")
		
	
func _on_pause_button_pressed() -> void:
	get_tree().paused = true
	pause_panel.show()
