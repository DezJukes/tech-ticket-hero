extends Node

@onready var info_panel = %InformationPanel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	var e_key_pressed = Input.is_action_just_pressed("interact")
	if (e_key_pressed == true):
		get_tree().paused = true
		info_panel.show()


func _on_accept_mission_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/System Architecture Gameplay/GameInterface.tscn")
