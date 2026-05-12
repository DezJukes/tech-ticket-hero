extends Node2D

@onready var pause_panel = %PausePanel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$CanvasLayer/Interact.disabled = not $SchoolComputer2/SchoolComputerInteractionZone.player_near

func _on_interact_pressed() -> void:
	if $SchoolComputer2/SchoolComputerInteractionZone.player_near:
		get_tree().change_scene_to_file("res://Scenes/Level 3 - Big Tech Company/Level 5 - Architecture/Banking_Architecture.tscn")
	else:
		print("You are too far from the computer to interact.")
		
	

func _on_pause_button_pressed() -> void:
	get_tree().paused = true
	pause_panel.show()
