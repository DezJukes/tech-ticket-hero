extends Node

@onready var pause_panel = %PausePanel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_button_pressed():
	get_tree().paused = true
	pause_panel.show()


func _on_interact_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level 1 - Beginner/Beginner - Architecture/Library_Architecture.tscn")
