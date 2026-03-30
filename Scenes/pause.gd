extends Node

@onready var pause_panel = %PausePanel
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	var esc_pressed = Input.is_action_just_pressed("pause")
	if (esc_pressed == true):
		get_tree().paused = true
		pause_panel.show()

# Will Resume the Game
func _on_resume_pressed():
	pause_panel.hide()
	get_tree().paused = false

# Button lead to Main Menu
func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")

# Button lead to Change Mode
func _on_change_mode_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menu/choose_mode.tscn")
