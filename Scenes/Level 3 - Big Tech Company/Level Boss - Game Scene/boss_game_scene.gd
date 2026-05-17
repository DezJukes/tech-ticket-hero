extends Node2D

@onready var pause_panel = %PausePanel
@onready var dashed_ring = $Boss/DashedRing
@onready var interaction_zone = $Boss/SchoolComputerInteractionZone
@onready var dialog_box = $GameIntroLevel2/TITLE/Control/Control/VBoxContainer2

@export var intro_scene_path: NodePath
@onready var intro_scene = get_node(intro_scene_path)

var player_near_computer := false
var was_player_near := false

func _process(delta: float) -> void:
	player_near_computer = interaction_zone.player_near

	$CanvasLayer/Interact.disabled = not player_near_computer

	if player_near_computer != was_player_near:
		dashed_ring.set_active(player_near_computer)
		was_player_near = player_near_computer

func _on_interact_pressed() -> void:
	if interaction_zone.player_near:
		# Player pressed interact! Go straight to the Game Complete screen.
		get_tree().change_scene_to_file("res://Scenes/Menu/Complete.tscn")
	else:
		print("You are too far from the computer to interact.")

func _on_pause_button_pressed() -> void:
	get_tree().paused = true
	pause_panel.show()
